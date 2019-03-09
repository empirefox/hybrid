protoc:
	protoc -I../../golang/protobuf/ptypes/empty --dart_out=grpc:app/lib/src/google/protobuf empty.proto
	protoc -I. --go_out=plugins=grpc:../../.. --dart_out=grpc:app/lib/src protos/authstore.proto
	protoc -I. --go_out=plugins=grpc:../../.. --dart_out=grpc:app/lib/src protos/config.proto
	protoc -I. --go_out=plugins=grpc:../../.. --dart_out=grpc:app/lib/src protos/grpc.proto
	protoc-go-inject-tag -input=config/config.pb.go
	protoc-go-inject-field -input=config/config.pb.go
	protoc -I. --dart-field-names_out=:app/lib/src protos/config.proto
	dartfmt -w app/lib/src/protos/*.fields.dart