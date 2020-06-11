class Sound {
private:
	int nrTrack;
	ALLEGRO_SAMPLE *menuMusicS;
	ALLEGRO_SAMPLE_INSTANCE *menuMusicI;
	ALLEGRO_SAMPLE *gotS;
	ALLEGRO_SAMPLE_INSTANCE *gotI;
	ALLEGRO_SAMPLE *t1S;
	ALLEGRO_SAMPLE_INSTANCE *t1I;
	ALLEGRO_SAMPLE *t2S;
	ALLEGRO_SAMPLE_INSTANCE *t2I;
	ALLEGRO_SAMPLE *t3S;
	ALLEGRO_SAMPLE_INSTANCE *t3I;
	ALLEGRO_SAMPLE *t4S;
	ALLEGRO_SAMPLE_INSTANCE *t4I;

	ALLEGRO_SAMPLE *pointS;
	ALLEGRO_SAMPLE_INSTANCE *pointI;
	ALLEGRO_SAMPLE *clickS;
	ALLEGRO_SAMPLE_INSTANCE *clickI;

	ALLEGRO_SAMPLE *shootS;
	ALLEGRO_SAMPLE *playerDieS;
	ALLEGRO_SAMPLE *zergDieS;
	ALLEGRO_SAMPLE *terranDieS;
	ALLEGRO_SAMPLE *protossDieS;

	ALLEGRO_SAMPLE *newUpS;
	ALLEGRO_SAMPLE *lifeS;
	ALLEGRO_SAMPLE *dmgS;

	bool mute;
public:
	Sound(Config &mConf);
	~Sound();

	void muteSound(Config &mConf);


	void menu();
	void game();
	void point();
	void click();
	void shoot();
	void playerDie();
	void zergDie();
	void terranDie();
	void protossDie();
	void upgrade(int type);
	void newUpgrade();
};