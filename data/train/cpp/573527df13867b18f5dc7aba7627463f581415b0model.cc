#include <fstream>
#include <boost/log/trivial.hpp>
#include "settings.h"
#include "utils/serialization/unordered_map.h"
#include "bestfirst/model/model.h"

namespace ZGen {
namespace BestFirst {

void wp(const ctx_t& ctx, std::vector<bs_t>& results) {
  results.clear();
  results.push_back( bs_t(ctx.word, ctx.tag) );
}

void w0w1(const ctx_t& ctx, std::vector<bs_t>& results) {
  results.clear();

  for (int i = 1; i < ctx.words.size(); ++ i) {
    const word_t& w0 = ctx.words[i- 1];
    const word_t& w1 = ctx.words[i];
    results.push_back( bs_t(w0, w1) );
  }
}

void p0p1(const ctx_t& ctx, std::vector<bs_t>& results) {
  results.clear();

  for (int i = 1; i < ctx.words.size(); ++ i) {
    const postag_t& p0 = ctx.postags[i- 1];
    const postag_t& p1 = ctx.postags[i];
    results.push_back( bs_t(p0, p1) );
  }
}

void hm(const ctx_t& ctx, std::vector<bs_t>& results) {
  results.clear();

  for (int i = 0; i < ctx.relations.size(); ++ i) {
    const int& hid = ctx.relations[i].first;
    const int& mid = ctx.relations[i].second;

    const word_t& hw = ctx.ref->forms[hid];
    const word_t& mw = ctx.ref->forms[mid];
    const postag_t& hp = ctx.ref->postags[hid];
    const postag_t& mp = ctx.ref->postags[mid];

    results.push_back( bs_t(hw, mw) );
    results.push_back( bs_t(hw, mp) );
    results.push_back( bs_t(hp, mw) );
    results.push_back( bs_t(hp, mp) );
  }
}

void hm3(const ctx_t& ctx, std::vector<ts_t>& results) {
  results.clear();

  for (int i = 0; i < ctx.relations.size(); ++ i) {
    const int& hid = ctx.relations[i].first;
    const int& mid = ctx.relations[i].second;

    const word_t& hw = ctx.ref->forms[hid];
    const word_t& mw = ctx.ref->forms[mid];
    const postag_t& hp = ctx.ref->postags[hid];
    const postag_t& mp = ctx.ref->postags[mid];

    results.push_back( ts_t(hw, hp, mw) );
    results.push_back( ts_t(hw, hp, mp) );
    results.push_back( ts_t(hw, mw, mw) );
    results.push_back( ts_t(hp, mw, mp) );
  }
}

Model::Model() {
  uscore_repo.reserve(64);
  bscore_repo.reserve(80);
  tscore_repo.reserve(80);

  uscore_repo.clear();
  bscore_repo.clear();
  tscore_repo.clear();

  bscore_repo.push_back( ScoreMap<bs_t>( wp ) );
  bscore_repo.push_back( ScoreMap<bs_t>( w0w1 ) );
  bscore_repo.push_back( ScoreMap<bs_t>( p0p1 ) );
  bscore_repo.push_back( ScoreMap<bs_t>( hm ) );
  tscore_repo.push_back( ScoreMap<ts_t>( hm3 ) );
}

floatval_t
Model::score(const Span& span, bool avg) const {
  ScoreContext ctx(span);
  return score(ctx, avg);
}

floatval_t
Model::score(const ScoreContext& ctx, bool avg) const {
  floatval_t ret = 0;
  for (int i = 0; i < uscore_repo.size(); ++ i) {
    ret += uscore_repo[i].score(ctx, avg, 0.);
  }

  for (int i = 0; i < bscore_repo.size(); ++ i) {
    ret += bscore_repo[i].score(ctx, avg, 0.);
  }

  for (int i = 0; i < tscore_repo.size(); ++ i) {
    ret += tscore_repo[i].score(ctx, avg, 0.);
  }

  return ret;
}

void
Model::update(const Span& span, int timestamp, floatval_t scale) {
  ScoreContext ctx(span);
  update(ctx, timestamp, scale);
}

void
Model::update(const ScoreContext& ctx, int timestamp, floatval_t scale) {
  for (int i = 0; i < uscore_repo.size(); ++ i) {
    uscore_repo[i].update(ctx, timestamp, scale);
  }

  for (int i = 0; i < bscore_repo.size(); ++ i) {
    bscore_repo[i].update(ctx, timestamp, scale);
  }

  for (int i = 0; i < tscore_repo.size(); ++ i) {
    tscore_repo[i].update(ctx, timestamp, scale);
  }
}

void
Model::flush(int timestamp) {
  for (int i = 0; i < uscore_repo.size(); ++ i) {
    uscore_repo[i].flush(timestamp);
  }

  for (int i = 0; i < bscore_repo.size(); ++ i) {
    bscore_repo[i].flush(timestamp);
  }

  for (int i = 0; i < tscore_repo.size(); ++ i) {
    tscore_repo[i].flush(timestamp);
  }
}

bool
Model::save(std::ostream& os) {
  boost::archive::text_oarchive oa(os);
  for (int i = 0; i < uscore_repo.size(); ++ i) {
    uscore_repo[i].save(oa);
  }

  for (int i = 0; i < bscore_repo.size(); ++ i) {
    bscore_repo[i].save(oa);
  }

  for (int i = 0; i < tscore_repo.size(); ++ i) {
    tscore_repo[i].save(oa);
  }

  return true;
}

bool
Model::load(std::istream& is) {
  boost::archive::text_iarchive ia(is);
  for (int i = 0; i < uscore_repo.size(); ++ i) {
    uscore_repo[i].load(ia);
  }

  for (int i = 0; i < bscore_repo.size(); ++ i) {
    bscore_repo[i].load(ia);
  }

  for (int i = 0; i < tscore_repo.size(); ++ i) {
    tscore_repo[i].load(ia);
  }

  return true;
}

} //  end for namespace BestFirst
} //  end for namespace ZGen
