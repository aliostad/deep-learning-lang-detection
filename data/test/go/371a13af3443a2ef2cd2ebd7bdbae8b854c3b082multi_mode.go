package store

import "yunxindao/msg"
import "yunxindao/db"

//MultiMode &&
type MultiMode struct {
	OverDispatch      ModeDispatch
	OverFilterTargets ModeFilterTargets
}

//Dispatch &&
func (mode *MultiMode) Dispatch(store *StateStoreRegistry, fromPartnerInfoItem *PartnerInfoItem, sessionItem *SessionItem, msg msg.Msg, toPartnerInfoItems map[uint64]*PartnerInfoItem) {
	if mode.OverDispatch != nil {
		mode.OverDispatch(db.ChannelMultiMode, store, fromPartnerInfoItem, sessionItem, msg, toPartnerInfoItems)
	}
}

//type ModeFilterTargets func(int, uint64, msg msg.Msg, channelPartners map[uint64]*ChannelItemPartner) map[uint64]*ChannelItemPartner
//FilterTargets &&
func (mode *MultiMode) FilterTargets(fromPartnerInfoItem *PartnerInfoItem, sessionItem *SessionItem, channel *ChannelInfoItem, msgBody msg.Msg) map[uint64]*PartnerInfoItem {
	if mode.OverFilterTargets != nil {
		return mode.OverFilterTargets(db.ChannelMultiMode, fromPartnerInfoItem, sessionItem, channel, msgBody)
	}
	return nil
}

