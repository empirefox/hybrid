package hybridtox

import tox "github.com/TokTok/go-toxcore-c"

var ToxNodes = []tox.BootstrapNode{
	{"node.tox.biribiri.org", 33445, 33445, *tox.MustDecodePubkey("F404ABAA1C99A9D37D61AB54898F56793E1DEF8BD46B1038B9D822E8460FAB67")},
	{"nodes.tox.chat", 33445, 33445, *tox.MustDecodePubkey("6FC41E2BD381D37E9748FC0E0328CE086AF9598BECC8FEB7DDF2E440475F300E")},
	{"130.133.110.14", 33445, 33445, *tox.MustDecodePubkey("461FA3776EF0FA655F1A05477DF1B3B614F7D6B124F7DB1DD4FE3C08B03B640F")},
	{"198.98.51.198", 33445, 33445, *tox.MustDecodePubkey("1D5A5F2F5D6233058BF0259B09622FB40B482E4FA0931EB8FD3AB8E7BF7DAF6F")},
	{"85.172.30.117", 33445, 33445, *tox.MustDecodePubkey("8E7D0B859922EF569298B4D261A8CCB5FEA14FB91ED412A7603A585A25698832")},
	{"194.249.212.109", 33445, 33445, *tox.MustDecodePubkey("3CEE1F054081E7A011234883BC4FC39F661A55B73637A5AC293DDF1251D9432B")},
	{"185.25.116.107", 33445, 33445, *tox.MustDecodePubkey("DA4E4ED4B697F2E9B000EEFE3A34B554ACD3F45F5C96EAEA2516DD7FF9AF7B43")},
	{"5.189.176.217", 5190, 5190, *tox.MustDecodePubkey("2B2137E094F743AC8BD44652C55F41DFACC502F125E99E4FE24D40537489E32F")},
}
