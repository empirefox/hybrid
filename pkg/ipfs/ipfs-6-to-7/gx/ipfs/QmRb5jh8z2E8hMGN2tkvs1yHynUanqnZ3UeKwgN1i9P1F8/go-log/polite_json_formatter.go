package log

import (
	"encoding/json"
	"io"

	logging "github.com/empirefox/hybrid/pkg/ipfs/ipfs-6-to-7/gx/ipfs/QmQvJiADDe7JR4m968MwXobTCCzUqQkP87aRHe29MEBGHV/go-logging"
)

// PoliteJSONFormatter marshals entries into JSON encoded slices (without
// overwriting user-provided keys). How polite of it!
type PoliteJSONFormatter struct{}

// Format encodes a logging.Record in JSON and writes it to Writer.
func (f *PoliteJSONFormatter) Format(calldepth int, r *logging.Record, w io.Writer) error {
	entry := make(map[string]interface{})
	entry["id"] = r.Id
	entry["level"] = r.Level
	entry["time"] = r.Time
	entry["module"] = r.Module
	entry["message"] = r.Message()
	err := json.NewEncoder(w).Encode(entry)
	if err != nil {
		return err
	}

	w.Write([]byte{'\n'})
	return nil
}
