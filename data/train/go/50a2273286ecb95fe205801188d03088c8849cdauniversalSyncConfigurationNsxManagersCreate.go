package go_nsx

type CertificateThumbprint struct {
	Text string `xml:",chardata" json:",omitempty"`
}

type IsPrimary struct {
	Text string `xml:",chardata" json:",omitempty"`
}

type NsxManagerInfo struct {
	CertificateThumbprint *CertificateThumbprint `xml:" certificateThumbprint,omitempty" json:"certificateThumbprint,omitempty"`
	IsPrimary             *IsPrimary             `xml:" isPrimary,omitempty" json:"isPrimary,omitempty"`
	NsxManagerIp          *NsxManagerIp          `xml:" nsxManagerIp,omitempty" json:"nsxManagerIp,omitempty"`
	NsxManagerPassword    *NsxManagerPassword    `xml:" nsxManagerPassword,omitempty" json:"nsxManagerPassword,omitempty"`
	NsxManagerUsername    *NsxManagerUsername    `xml:" nsxManagerUsername,omitempty" json:"nsxManagerUsername,omitempty"`
}

type NsxManagerIp struct {
	Text string `xml:",chardata" json:",omitempty"`
}

type NsxManagerPassword struct {
	Text string `xml:",chardata" json:",omitempty"`
}

type NsxManagerUsername struct {
	Text string `xml:",chardata" json:",omitempty"`
}

type Root struct {
	NsxManagerInfo *NsxManagerInfo `xml:" nsxManagerInfo,omitempty" json:"nsxManagerInfo,omitempty"`
}
