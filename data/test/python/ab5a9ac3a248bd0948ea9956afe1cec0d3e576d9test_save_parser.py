import sure  # noqa
from save_parser import SaveDataGen1


def test_basic_functionality():
    with open('test_save.sav', 'rb') as f:
        save = SaveDataGen1(f.read())

    save.money.should.equal(40398)
    save.trainer_name.should.equal('RED')
    save.trainer_id.should.equal(20152)
    save.rival_name.should.equal('BLUE')
    save.party_size.should.equal(6)

    len(save.party).should.equal(6)

    battery_jesus = save.party[0]
    battery_jesus.species.should.equal('Zapdos')
    battery_jesus.nickname.should.equal('AA-j')
    battery_jesus.trainer_id.should.equal(save.trainer_id)
    len(battery_jesus.moves).should.equal(4)
    battery_jesus.move_names[3].should.equal('Thunder')
    battery_jesus.level.should.equal(81)
    battery_jesus.index.should.equal(0x4B)
    battery_jesus.pokedex_num.should.equal('145')

    bird_jesus = save.party[5]
    bird_jesus.species.should.equal('Pidgeot')
    bird_jesus.trainer_name.should.equal('RED')
    bird_jesus.nickname.should.equal('aaabaaajss')
    bird_jesus.exp.should.equal(343472)
    bird_jesus.index.should.equal(0x97)
    bird_jesus.pokedex_num.should.equal('018')

    lord_helix = save.party[2]
    lord_helix.species.should.equal('Omastar')
    lord_helix.nickname.should.equal('OMASTAR')
    lord_helix.hp_curr.should.equal(0)
    lord_helix.hp_max.should.equal(154)

    air_jordan = save.party[4]
    air_jordan.species.should.equal('Lapras')
    air_jordan.nickname.should.equal('AIIIIIIRRR')
    air_jordan.level.should.equal(31)


def test_bad_terminator_handling():
    """
    Loading this data should not throw an exception. If it does, SaveDataGen1
    is handling the 0x50 terminator improperly.
    """
    with open('test_save_term.sav', 'rb') as f:
        SaveDataGen1(f.read())
