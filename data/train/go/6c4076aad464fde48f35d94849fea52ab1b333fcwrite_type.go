package wire

// WriteType represents a write type.
type WriteType string

const (
	// WriteTypeMustCache means the data will be stored in Alluxio.
	WriteTypeMustCache WriteType = "MUST_CACHE"
	// WriteTypeCacheThrough means the data will be stored in Alluxio and
	// synchronously written to UFS.
	WriteTypeCacheThrough = "CACHE_THROUGH"
	// WriteTypeThrough means the data will be sychrounously written to UFS.
	WriteTypeThrough = "THROUGH"
	// WriteTypeAsyncThrough means the data will be stored in Alluxio and
	// asynchrounously written to UFS.
	WriteTypeAsyncThrough = "ASYNC_THROUGH"
	// WriteTypeNone means the data will no be stored.
	WriteTypeNone = "NONE"
)
