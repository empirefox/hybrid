// Code generated by protoc-gen-go. DO NOT EDIT.
// source: protos/config.proto

package config // import "github.com/empirefox/hybrid/config"

import proto "github.com/golang/protobuf/proto"
import fmt "fmt"
import math "math"

// Reference imports to suppress errors if they are not otherwise used.
var _ = proto.Marshal
var _ = fmt.Errorf
var _ = math.Inf

// This is a compile-time assertion to ensure that this generated file
// is compatible with the proto package it is being compiled against.
// A compilation error at this line likely means your copy of the
// proto package needs to be updated.
const _ = proto.ProtoPackageIsVersion2 // please upgrade the proto package

type ConfigTree struct {
	Version              string   `protobuf:"bytes,1,opt,name=version,proto3" json:"version,omitempty"`
	RootName             string   `protobuf:"bytes,2,opt,name=root_name,json=rootName,proto3" json:"root_name,omitempty"`
	RootPath             string   `protobuf:"bytes,3,opt,name=root_path,json=rootPath,proto3" json:"root_path,omitempty"`
	ConfigName           string   `protobuf:"bytes,4,opt,name=config_name,json=configName,proto3" json:"config_name,omitempty"`
	ConfigPath           string   `protobuf:"bytes,5,opt,name=config_path,json=configPath,proto3" json:"config_path,omitempty"`
	IpfsName             string   `protobuf:"bytes,6,opt,name=ipfs_name,json=ipfsName,proto3" json:"ipfs_name,omitempty"`
	IpfsPath             string   `protobuf:"bytes,7,opt,name=ipfs_path,json=ipfsPath,proto3" json:"ipfs_path,omitempty"`
	StoreName            string   `protobuf:"bytes,8,opt,name=store_name,json=storeName,proto3" json:"store_name,omitempty"`
	StorePath            string   `protobuf:"bytes,9,opt,name=store_path,json=storePath,proto3" json:"store_path,omitempty"`
	FilesRootName        string   `protobuf:"bytes,10,opt,name=files_root_name,json=filesRootName,proto3" json:"files_root_name,omitempty"`
	FilesRootPath        string   `protobuf:"bytes,11,opt,name=files_root_path,json=filesRootPath,proto3" json:"files_root_path,omitempty"`
	RulesRootName        string   `protobuf:"bytes,12,opt,name=rules_root_name,json=rulesRootName,proto3" json:"rules_root_name,omitempty"`
	RulesRootPath        string   `protobuf:"bytes,13,opt,name=rules_root_path,json=rulesRootPath,proto3" json:"rules_root_path,omitempty"`
	XXX_NoUnkeyedLiteral struct{} `json:"-"`
	XXX_unrecognized     []byte   `json:"-"`
	XXX_sizecache        int32    `json:"-"`
}

func (m *ConfigTree) Reset()         { *m = ConfigTree{} }
func (m *ConfigTree) String() string { return proto.CompactTextString(m) }
func (*ConfigTree) ProtoMessage()    {}
func (*ConfigTree) Descriptor() ([]byte, []int) {
	return fileDescriptor_config_153134dd7847dcfb, []int{0}
}
func (m *ConfigTree) XXX_Unmarshal(b []byte) error {
	return xxx_messageInfo_ConfigTree.Unmarshal(m, b)
}
func (m *ConfigTree) XXX_Marshal(b []byte, deterministic bool) ([]byte, error) {
	return xxx_messageInfo_ConfigTree.Marshal(b, m, deterministic)
}
func (dst *ConfigTree) XXX_Merge(src proto.Message) {
	xxx_messageInfo_ConfigTree.Merge(dst, src)
}
func (m *ConfigTree) XXX_Size() int {
	return xxx_messageInfo_ConfigTree.Size(m)
}
func (m *ConfigTree) XXX_DiscardUnknown() {
	xxx_messageInfo_ConfigTree.DiscardUnknown(m)
}

var xxx_messageInfo_ConfigTree proto.InternalMessageInfo

func (m *ConfigTree) GetVersion() string {
	if m != nil {
		return m.Version
	}
	return ""
}

func (m *ConfigTree) GetRootName() string {
	if m != nil {
		return m.RootName
	}
	return ""
}

func (m *ConfigTree) GetRootPath() string {
	if m != nil {
		return m.RootPath
	}
	return ""
}

func (m *ConfigTree) GetConfigName() string {
	if m != nil {
		return m.ConfigName
	}
	return ""
}

func (m *ConfigTree) GetConfigPath() string {
	if m != nil {
		return m.ConfigPath
	}
	return ""
}

func (m *ConfigTree) GetIpfsName() string {
	if m != nil {
		return m.IpfsName
	}
	return ""
}

func (m *ConfigTree) GetIpfsPath() string {
	if m != nil {
		return m.IpfsPath
	}
	return ""
}

func (m *ConfigTree) GetStoreName() string {
	if m != nil {
		return m.StoreName
	}
	return ""
}

func (m *ConfigTree) GetStorePath() string {
	if m != nil {
		return m.StorePath
	}
	return ""
}

func (m *ConfigTree) GetFilesRootName() string {
	if m != nil {
		return m.FilesRootName
	}
	return ""
}

func (m *ConfigTree) GetFilesRootPath() string {
	if m != nil {
		return m.FilesRootPath
	}
	return ""
}

func (m *ConfigTree) GetRulesRootName() string {
	if m != nil {
		return m.RulesRootName
	}
	return ""
}

func (m *ConfigTree) GetRulesRootPath() string {
	if m != nil {
		return m.RulesRootPath
	}
	return ""
}

func init() {
	proto.RegisterType((*ConfigTree)(nil), "protos.ConfigTree")
}

func init() { proto.RegisterFile("protos/config.proto", fileDescriptor_config_153134dd7847dcfb) }

var fileDescriptor_config_153134dd7847dcfb = []byte{
	// 265 bytes of a gzipped FileDescriptorProto
	0x1f, 0x8b, 0x08, 0x00, 0x00, 0x09, 0x6e, 0x88, 0x02, 0xff, 0x5c, 0x91, 0x41, 0x4b, 0xc3, 0x40,
	0x10, 0x85, 0xa9, 0xd5, 0xb6, 0x99, 0x5a, 0x84, 0x78, 0x09, 0x88, 0x28, 0x45, 0xc4, 0x53, 0x73,
	0xf0, 0x1f, 0xe8, 0x5d, 0xa4, 0x78, 0xf2, 0x52, 0x9a, 0xba, 0x69, 0x16, 0x4c, 0x26, 0xcc, 0x6e,
	0x45, 0xff, 0x9a, 0xbf, 0xce, 0xe4, 0x8d, 0x69, 0xb6, 0x3d, 0xce, 0xfb, 0xde, 0xf7, 0x42, 0x58,
	0xba, 0xac, 0x85, 0x3d, 0xbb, 0x74, 0xc3, 0x55, 0x6e, 0xb7, 0x0b, 0x5c, 0xf1, 0x48, 0xc3, 0xf9,
	0xef, 0x90, 0xe8, 0x19, 0xe0, 0x4d, 0x8c, 0x89, 0x13, 0x1a, 0x7f, 0x19, 0x71, 0x96, 0xab, 0x64,
	0x70, 0x3b, 0x78, 0x88, 0x96, 0xdd, 0x19, 0x5f, 0x51, 0x24, 0xcc, 0x7e, 0x55, 0xad, 0x4b, 0x93,
	0x9c, 0x80, 0x4d, 0xda, 0xe0, 0xa5, 0xb9, 0xf7, 0xb0, 0x5e, 0xfb, 0x22, 0x19, 0xf6, 0xf0, 0xb5,
	0xb9, 0xe3, 0x1b, 0x9a, 0xea, 0xa7, 0xd5, 0x3d, 0x05, 0x26, 0x8d, 0x60, 0xf7, 0x05, 0xf8, 0x67,
	0x61, 0x01, 0x0b, 0xcd, 0xbc, 0xad, 0x73, 0xa7, 0xfe, 0x48, 0xe7, 0xdb, 0xa0, 0xfb, 0x36, 0x20,
	0xdc, 0x71, 0x0f, 0x61, 0x5e, 0x13, 0x39, 0xcf, 0x62, 0x54, 0x9d, 0x80, 0x46, 0x48, 0xe0, 0xee,
	0x31, 0xe4, 0x28, 0xc0, 0xb0, 0xef, 0xe9, 0x22, 0xb7, 0x9f, 0xc6, 0xad, 0xfa, 0x3f, 0x27, 0x74,
	0x66, 0x88, 0x97, 0xdd, 0xef, 0x1f, 0xf6, 0xb0, 0x35, 0x3d, 0xea, 0x75, 0x7b, 0xb2, 0x3b, 0xdc,
	0x3b, 0xd7, 0x1e, 0xe2, 0x70, 0x2f, 0xe8, 0x61, 0x6f, 0x76, 0xd4, 0x6b, 0xf7, 0x9e, 0xee, 0xde,
	0xe7, 0x5b, 0xeb, 0x8b, 0x5d, 0xb6, 0xd8, 0x70, 0x99, 0x9a, 0xb2, 0xb6, 0x62, 0x72, 0xfe, 0x4e,
	0x8b, 0x9f, 0x4c, 0xec, 0xc7, 0xff, 0x83, 0x67, 0xfa, 0xd4, 0x8f, 0x7f, 0x01, 0x00, 0x00, 0xff,
	0xff, 0xe3, 0xcf, 0xd4, 0x7d, 0x08, 0x02, 0x00, 0x00,
}
