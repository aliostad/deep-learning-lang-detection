#include <goban.hh>
#include <gtp.hh>

template<unsigned short n>
void
eye_capture(Goban<n> g)
{
  g.play(2, 3, Black);
  g.play(3, 3, White);
  g.play(2, 6, Black);
  g.play(3, 4, White);
  g.play(2, 4, White);
  g.play(1, 3, White);

  /* White captures one black stone */

  g.play(2, 2, White);
  g.play(1, 2, White);


  g.play(0, 2, Black);
  g.play(0, 3, Black);
  g.play(1, 1, Black);
  g.play(1, 4, Black);
  g.play(2, 1, Black);

  g.play(3, 2, Black);
  g.play(2, 5, Black);
  g.play(3, 5, Black);
  g.play(4, 3, Black);
  g.play(4, 4, Black);
  g.dump();
  g.dump_groups();
  g.play(2, 3, Black);
  g.dump();
  g.dump_groups();

  /* Black kills the white false-eye */

  g.play(0, 1, Black);
  g.play(0, 4, Black);
  g.play(3, 1, Black);
  g.play(4, 2, Black);
  g.play(2, 4, Black);

  g.dump();
  g.dump_groups();

  /* And forms two eyes */

}

template<unsigned short n>
void
links(Goban<n> g)
{
  g.play(6, 5, Black);
  g.play(8, 7, Black);
  g.play(10, 5, Black);
  g.play(8, 3, Black);

  g.dump();
  g.dump_groups();
  g.dump_links();

  g.play(7, 5, Black);
  g.play(8, 4, Black);
  g.play(8, 6, Black);
  g.play(9, 5, Black);
  g.dump();
  g.dump_groups();
  g.dump_links();
}

template<unsigned short n>
void
atari(Goban<n> g)
{
  g.play(7, 5, White);
  g.play(7, 6, White);
  g.play(7, 4, Black);
  g.play(6, 5, Black);
  g.play(6, 6, Black);
  g.play(7, 7, Black);
  g.play(8, 6, Black);
  g.dump();

  g.act_on_atari(White);
  g.dump();
  g.act_on_atari(Black);
  g.dump();

  g.act_on_atari(White);
  g.dump();
  g.act_on_atari(Black);
  g.dump();

  g.act_on_atari(White);
  g.dump();
  g.act_on_atari(Black);
  g.dump();

  g.act_on_atari(White);
  g.dump();
  g.act_on_atari(Black);
  g.dump();

  g.act_on_atari(White);
  g.dump();
  g.act_on_atari(Black);
  g.dump();

  g.act_on_atari(White);
  g.dump();
  g.act_on_atari(Black);
  g.dump();
}

int main()
{
  gtp_loop();
  //Goban<19> goban;
  //eye_capture(goban);
  //links(goban);
  //atari(goban);
}
