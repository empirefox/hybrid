package config

type routerItem struct {
	Name  string       `toml:",omitempty"`
	Adp   *AdpRouter   `toml:",omitempty"`
	Ipnet *IPNetRouter `toml:",omitempty"`
}

func (m *RouterItem) MarshalTOML() (interface{}, error) {
	return &routerItem{
		Name:  m.Name,
		Adp:   m.GetAdp(),
		Ipnet: m.GetIpnet(),
	}, nil
}

func (m *RouterItem) UnmarshalTOML(decode func(interface{}) error) error {
	var dec routerItem
	if err := decode(&dec); err != nil {
		return err
	}

	*m = RouterItem{Name: dec.Name}
	if dec.Adp != nil {
		m.Router = &RouterItem_Adp{dec.Adp}
	} else {
		m.Router = &RouterItem_Ipnet{dec.Ipnet}
	}
	return nil
}
