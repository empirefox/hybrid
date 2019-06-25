package grpc

import (
	"github.com/empirefox/hybrid/config"
	"github.com/empirefox/hybrid/pkg/zapsuit"
	"go.uber.org/zap"
	"go.uber.org/zap/zapcore"
)

func NewLogger(c *config.Log, options ...zap.Option) (*zap.Logger, error) {
	if c == nil {
		c = new(config.Log)
	}
	zapsuitConfig := zapsuit.Config{
		Dev:    c.Dev,
		Target: c.Target,
	}
	if c.Level != "" {
		var level zapcore.Level
		err := level.Set(c.Level)
		if err != nil {
			return nil, err
		}
		zapsuitConfig.Level = &level
	}
	return zapsuit.NewZap(&zapsuitConfig, options...)
}
