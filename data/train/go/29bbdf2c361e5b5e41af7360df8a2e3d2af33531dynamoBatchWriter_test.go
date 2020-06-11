package main

import (
	"testing"

	"github.com/aws/aws-sdk-go/service/dynamodb"
)

func TestBatchWrite(t *testing.T) {
	fakeOutput := dynamodb.BatchWriteItemOutput{}
	dynamoClient := &_FakeDynamoDBBatchWriteClient{_fakeOutput: &fakeOutput}
	batchWriter := _DynamoDBBatchWriter{dynamoClient}
	batchWriteItemInput := dynamodb.BatchWriteItemInput{}
	batchWriteOutput, _ := batchWriter.BatchWriteItem(&batchWriteItemInput)

	if batchWriteOutput != &fakeOutput {
		t.Fatal("Expected that output from dynamodb client is returned back to the caller")
	}

	if dynamoClient._input != &batchWriteItemInput {
		t.Fatal("Expected that BatchWriteItemInput is passed to dynamodb client")
	}
}

type _FakeDynamoDBBatchWriteClient struct {
	_input      *dynamodb.BatchWriteItemInput
	_fakeOutput *dynamodb.BatchWriteItemOutput
}

func (d *_FakeDynamoDBBatchWriteClient) BatchWriteItem(input *dynamodb.BatchWriteItemInput) (*dynamodb.BatchWriteItemOutput, error) {
	d._input = input
	return d._fakeOutput, nil
}
