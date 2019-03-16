#VERSION := $(shell git describe --tags)
VERSION := $(shell git rev-parse --short HEAD)
GOMOBILE_PKG := github.com/empirefox/hybrid/gomobile
APP_PATH := ./app

echo:
	@echo GOMOBILE_PKG=${GOMOBILE_PKG}
	@echo APP_PATH=${APP_PATH}
	@echo VERSION=${VERSION}

bind-android:
	gomobile bind -target android -o ${APP_PATH}/android/go/go.aar \
		${GOMOBILE_PKG} \
		github.com/empirefox/flutter_dial_go/go/formobile

bind-ios:
	gomobile bind -target ios -o ${APP_PATH}/ios/Frameworks/Gomobile.framework \
		${GOMOBILE_PKG} \
		github.com/empirefox/flutter_dial_go/go/formobile

clean:
	rm -f ${APP_PATH}/android/go/*.aar
	rm -f ${APP_PATH}/android/go/*.jar
	rm -rf ${APP_PATH}/ios/Frameworks/Gomobile.framework


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
