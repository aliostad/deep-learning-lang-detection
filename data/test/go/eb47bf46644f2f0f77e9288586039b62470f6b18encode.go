package cat

import "bytes"
import "strconv"
import "encoding/binary"
import "strings"
import "fmt"
import . "os"

type Encodable interface {
	Encode(*bytes.Buffer) error
}

func (t *transaction) Encode(buf *bytes.Buffer) error {
	if t.children == nil || len(t.children) == 0 {
		buf.WriteString("A")
		buf.WriteString(t.start.Format("2006-01-02 15:04:05.000"))
		buf.WriteString(TAB)
		buf.WriteString(t.GetType())
		buf.WriteString(TAB)
		buf.WriteString(t.GetName())
		buf.WriteString(TAB)
		buf.WriteString(t.GetStatus())
		buf.WriteString(TAB)
		buf.WriteString(strconv.FormatInt(int64(t.duration/1000), 10))
		buf.WriteString("us")
		buf.WriteString(TAB)
		buf.Write(t.GetData())
		buf.WriteString(TAB)
		buf.WriteString(LF)
	} else {
		buf.WriteString("t")
		buf.WriteString(t.start.Format("2006-01-02 15:04:05.000"))
		buf.WriteString(TAB)
		buf.WriteString(t.GetType())
		buf.WriteString(TAB)
		buf.WriteString(t.GetName())
		buf.WriteString(TAB)
		buf.WriteString(LF)
		for _, child := range t.children {
			child.Encode(buf)
		}
		buf.WriteString("T")
		buf.WriteString(t.end.Format("2006-01-02 15:04:05.000"))
		buf.WriteString(TAB)
		buf.WriteString(t.GetType())
		buf.WriteString(TAB)
		buf.WriteString(t.GetName())
		buf.WriteString(TAB)
		buf.WriteString(t.GetStatus())
		buf.WriteString(TAB)
		buf.WriteString(strconv.FormatInt(int64(t.duration/1000), 10))
		buf.WriteString("us")
		buf.WriteString(TAB)
		buf.Write(t.GetData())
		buf.WriteString(TAB)
		buf.WriteString(LF)
	}
	return nil
}

func (h event) Encode(buf *bytes.Buffer) error {
	buf.WriteString("E")
	buf.WriteString(h.GetTimestamp().Format("2006-01-02 15:04:05.000"))
	buf.WriteString(TAB)
	buf.WriteString(h.GetType())
	buf.WriteString(TAB)
	buf.WriteString(h.GetName())
	buf.WriteString(TAB)
	buf.WriteString(h.GetStatus())
	buf.WriteString(TAB)
	buf.Write(h.GetData())
	buf.WriteString(TAB)
	buf.WriteString(LF)
	return nil
}

//refactor expected.
func (h heartbeat) Encode(buf *bytes.Buffer) error {
	buf.WriteString("H")
	buf.WriteString(h.GetTimestamp().Format("2006-01-02 15:04:05.000"))
	buf.WriteString(TAB)
	buf.WriteString(h.GetType())
	buf.WriteString(TAB)
	buf.WriteString(h.GetName())
	buf.WriteString(TAB)
	buf.WriteString(h.GetStatus())
	buf.WriteString(TAB)
	buf.Write(h.GetData())
	buf.WriteString(TAB)
	buf.WriteString(LF)
	return nil
}

func (h header) Encode(buf *bytes.Buffer) error {
	buf.WriteString("PT1")
	buf.WriteString(TAB)
	buf.WriteString(h.m_domain)
	buf.WriteString(TAB)
	buf.WriteString(h.m_hostname)
	buf.WriteString(TAB)
	buf.WriteString(h.m_ipAddress)
	buf.WriteString(TAB)
	buf.WriteString("_")
	buf.WriteString(TAB)
	buf.WriteString(strconv.Itoa(Getpid()))
	buf.WriteString(TAB)
	buf.WriteString("_")
	buf.WriteString(TAB)
	mid, err := MESSAGE_ID_FACTORY.Next()
	mid.Encode(buf)
	buf.WriteString(TAB)
	buf.WriteString("null")
	buf.WriteString(TAB)
	buf.WriteString("null")
	buf.WriteString(TAB)
	buf.WriteString("null")
	buf.WriteString(TAB)
	buf.WriteString(LF)
	return err
}

func (mid message_id) Encode(buf *bytes.Buffer) error {
	buf.WriteString(mid.GetDomain())
	buf.WriteString("-")
	buf.WriteString(iptohex(mid.GetIpAddress()))
	buf.WriteString("-")
	buf.WriteString(fmt.Sprintf("%d", mid.tsh))
	buf.WriteString("-")
	buf.WriteString(fmt.Sprintf("%d", mid.index))
	return nil
}

func int32tobytes(i int32) []byte {
	buf := bytes.NewBuffer([]byte{})
	binary.Write(buf, binary.BigEndian, i)
	return buf.Bytes()
}

func iptohex(ip string) string {
	var strs []string = strings.Split(ip, ".")
	for i := 0; i < 4; i++ {
		digit, _ := strconv.Atoi(strs[i])
		strs[i] = fmt.Sprintf("%x", digit)
		if len(strs[i]) < 2 {
			strs[i] = "0" + strs[i]
		}
	}
	return strings.Join(strs, "")
}
