protoc:
	protoc -I../../golang/protobuf/ptypes/empty --dart_out=grpc:app/lib/src/google/protobuf empty.proto
	protoc -I. --go_out=plugins=grpc:../../.. --dart_out=grpc:app/lib/src protos/authstore.proto
	protoc -I. --go_out=plugins=grpc:../../.. --dart_out=grpc:app/lib/src protos/config.proto
	protoc -I. --go_out=plugins=grpc:../../.. --dart_out=grpc:app/lib/src protos/validators.proto
	protoc -I. --go_out=plugins=grpc:../../.. --dart_out=grpc:app/lib/src protos/grpc.proto
	protoc-go-inject-tag -input=config/config.pb.go
	protoc-go-inject-field -input=config/config.pb.go

	protoc -I. --dart-ext_out=dart_ext=defaults+field_names+field_l10n:app/lib/src protos/config.proto
	dartfmt -w app/lib/src/protos/*.field.names.dart
	dartfmt -w app/lib/src/protos/*.field.l10n.dart
	mv app/lib/src/protos/*.field.l10n.dart app/lib/src/l10n/

l10n:
	cd app && flutter pub pub run intl_translation:extract_to_arb --output-dir=lib/src/l10n lib/src/l10n/*.l10n.dart
	cd app && flutter pub pub run intl_translation:generate_from_arb --output-dir=lib/src/l10n --no-use-deferred-loading lib/src/l10n/*.l10n.dart lib/src/l10n/intl_*.arb