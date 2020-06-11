package bars

import (
	"log"
	"net"
	"os"

	"go.uber.org/zap"

	context "golang.org/x/net/context"
	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials"

	"bytes"

	"fmt"
	"image/png"

	"time"

	"github.com/boombuler/barcode"
	"github.com/boombuler/barcode/ean"
	"github.com/boombuler/barcode/qr"
	"github.com/gernest/cerealous/internal"
	"github.com/gernest/cerealous/keys"
	"github.com/gernest/cerealous/models"
	"github.com/gernest/cerealous/proto/barcodes"
	"github.com/ngorm/ngorm"

	// import database drivers
	_ "github.com/ngorm/postgres"
	_ "github.com/ngorm/ql"
	"github.com/urfave/cli"
)

const appName = "barcode-generator"

var zappy *zap.Logger
var host string

func init() {
	e := os.Getenv("CEREAL_ENV")
	var err error
	switch e {
	case "dev":
		zappy, err = zap.NewDevelopment()
		if err != nil {
			log.Fatal(err)
		}
	default:
		zappy, err = zap.NewProduction()
		if err != nil {
			log.Fatal(err)
		}
	}
	host, err = os.Hostname()
	if err != nil {
		log.Fatal(err)
	}
	zappy = zappy.With(
		zap.String(keys.Host, host),
		zap.String(keys.AppName, appName),
	)
}

type barServer struct {
	DB      *ngorm.DB
	verbose bool
}

// NewServer returns a pRPC server implementation for generating barcods
func NewServer(db *ngorm.DB) barcodes.BarcodeGenServer {
	return &barServer{DB: db}
}

// Generate generates a new barcode based on the req.
func (s *barServer) Generate(ctx context.Context,
	req *barcodes.GenerateReq) (*barcodes.GenerateRes, error) {
	message := "generate new barcode"
	instrument := internal.NewLogFields().
		Common(zap.Int64(keys.UserID, req.UserID))
	defer func() {
		instrument.Flush(zappy)
	}()
	u := &models.User{}
	if err := s.DB.Begin().First(u, req.GetUserID()); err != nil {
		instrument.New().Message(message).Error(
			zap.String(keys.DatabaseError, err.Error()),
		)
		return nil, err
	}
	var buf bytes.Buffer
	var e barcode.Barcode
	var err error
	switch req.Kind {
	case barcodes.Kind_QR:
		e, err = qr.Encode(req.Data, qr.H, qr.Unicode)
		if err != nil {
			instrument.New().Message(message).Error(
				zap.String(keys.BarcodeGenerationError, err.Error()),
				zap.String(keys.BarcodeKind, req.Kind.ToString()),
			)
			return nil, err
		}
	case barcodes.Kind_Ean8:
		e, err = ean.Encode(req.Data)
		if err != nil {
			instrument.New().Message(message).Error(
				zap.Int64(keys.UserID, req.UserID),
				zap.String(keys.BarcodeGenerationError, err.Error()),
				zap.String(keys.BarcodeKind, req.Kind.ToString()),
			)
			return nil, err
		}
	}
	e, err = barcode.Scale(e, int(req.Width), int(req.Height))
	if err != nil {
		instrument.New().Message(message).Error(
			zap.String(keys.BarcodeScaleError, err.Error()),
			zap.String(keys.BarcodeKind, req.Kind.ToString()),
			zap.Int64(keys.BarcodeWidth, req.Width),
			zap.Int64(keys.BarcodeHeight, req.Height),
		)
		return nil, err
	}
	err = png.Encode(&buf, e)
	if err != nil {
		instrument.New().Message(message).Error(
			zap.String(keys.BarcodeEncodingError, err.Error()),
			zap.String(keys.BarcodeKind, req.Kind.ToString()),
		)
		return nil, err
	}

	//barcode
	now := time.Now()
	b := &models.Barcode{
		Data:   req.GetData(),
		UUID:   internal.NewUUID(),
		UserID: u.ID,
	}
	b.CreatedAt = now
	b.Blob = models.Blob{
		Data: buf.Bytes(),
	}
	b.Blob.CreatedAt = now

	err = s.DB.Begin().Create(b)
	if err != nil {
		instrument.New().Message(message).Error(
			zap.String(keys.DatabaseError, err.Error()),
		)
		return nil, err
	}
	instrument.New().Message(message).Info(
		zap.String(keys.BarcodeUUID, b.UUID),
	)
	return &barcodes.GenerateRes{
		UUID: b.UUID,
	}, nil
}

// Command returns cli.Command fo barcode generation service
func Command() cli.Command {
	return cli.Command{
		Name:   "bar",
		Usage:  "start barcode generation rpc service",
		Action: barService,
		Flags: []cli.Flag{
			cli.StringFlag{
				Name:   keys.DBDriverFlag,
				Usage:  "database to use e.g postgres/ql/ql-mem",
				EnvVar: "CEREAL_DATABASE_DRIVER",
			},
			cli.StringFlag{
				Name:   keys.DBConnFlag,
				Usage:  "database connection url",
				EnvVar: "CEREAL_DATABASE_CONNECTION",
			},
			cli.IntFlag{
				Name:   keys.PortFlag,
				Usage:  "port number to bind the rpc server",
				EnvVar: "CEREAL_PORT",
			},
			cli.StringFlag{
				Name:   keys.ServerCertFlag,
				Usage:  "The rpc server ssl certificate",
				EnvVar: "CEREAL_SERVER_CERT",
			},
			cli.StringFlag{
				Name:   keys.ServerKeyFlag,
				Usage:  "The rpc server ssl key",
				EnvVar: "CEREAL_SERVER_KEY",
			},
			cli.StringFlag{
				Name:   keys.CAFlag,
				Usage:  "The certificate authority used to sign the certs",
				EnvVar: "CEREAL_CA",
			},
			cli.BoolFlag{
				Name:   keys.SSLFlag,
				Usage:  "Set this true to enable ssl",
				EnvVar: "CEREAL_SSL",
			},
		},
	}
}

func barService(ctx *cli.Context) error {
	instrument := internal.NewLogFields()
	defer func() {
		instrument.Flush(zappy)
	}()
	driver, err := internal.GetDriver(ctx)
	if err != nil {
		instrument.Info(
			zap.String(keys.FlagsError, err.Error()),
		)
		return err
	}
	conn, err := internal.GetConn(ctx)
	if err != nil {
		instrument.Info(
			zap.String(keys.FlagsError, err.Error()),
		)
		return err
	}
	port, err := internal.GetPort(ctx)
	if err != nil {
		instrument.Info(
			zap.String(keys.FlagsError, err.Error()),
		)
		return err
	}
	db, err := ngorm.Open(driver, conn)
	if err != nil {
		instrument.Info(
			zap.String(keys.FlagsError, err.Error()),
		)
		return err
	}

	ssl := ctx.Bool("ssl")
	if !ssl {
		lis, err := net.Listen("tcp", fmt.Sprintf(":%d", port))
		if err != nil {
			instrument.Info(
				zap.Int(keys.Port, port),
				zap.String(keys.ListeningError, err.Error()),
			)
			return err
		}
		defer lis.Close()
		rpcServer := grpc.NewServer()
		barcodes.RegisterBarcodeGenServer(rpcServer, NewServer(db))
		zappy.Info("started barcode service without mutual tls",
			zap.String("url", lis.Addr().String()),
		)
		return rpcServer.Serve(lis)
	}
	tlsConfig, err := internal.ServerTLS(ctx)
	if err != nil {
		instrument.Error(
			zap.String(keys.FlagsError, err.Error()),
		)
		return err
	}

	lis, err := net.Listen("tcp", fmt.Sprintf(":%d", port))
	if err != nil {
		instrument.Error(
			zap.Int(keys.Port, port),
			zap.String(keys.ListeningError, err.Error()),
		)
		return err
	}

	rpcServer := grpc.NewServer(grpc.Creds(
		credentials.NewTLS(tlsConfig),
	))
	barcodes.RegisterBarcodeGenServer(rpcServer, NewServer(db))
	zappy.Info("started barcode service with mutual tls",
		zap.String("url", lis.Addr().String()),
	)
	return rpcServer.Serve(lis)
}
