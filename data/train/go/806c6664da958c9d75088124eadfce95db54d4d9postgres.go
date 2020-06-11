package postgres

import (
	"database/sql"
	"fmt"

	_ "leaguelog/Godeps/_workspace/src/github.com/lib/pq"
)

type PgManager struct {
	db *sql.DB
}

type PgRepository struct {
	manager *PgManager
}

func NewPgRepository(manager *PgManager) *PgRepository {
	repo := &PgRepository{
		manager: manager,
	}

	return repo
}

func (repo *PgRepository) Close() error {
	if repo.manager != nil {
		return repo.manager.close()
	}

	fmt.Println("No Postgres manager found for repo.")
	return nil
}

func NewPgManager(url string) (*PgManager, error) {
	manager := &PgManager{}
	err := manager.open(url)
	if err != nil {
		return nil, err
	}

	return manager, nil
}

func (manager *PgManager) open(url string) error {
	var err error

	if manager.db == nil {
		manager.db, err = sql.Open("postgres", url)

		return err
	}

	return err
}

func (manager *PgManager) close() error {
	err := manager.db.Close()
	if err != nil {
		return err
	}

	manager.db = nil

	return nil
}
