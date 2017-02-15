/*
  arrayops.c: array operators

  Copyright (C) 2017 Victor Lazzarini
  This file is part of Csound.

  The Csound Library is free software; you can redistribute it
  and/or modify it under the terms of the GNU Lesser General Public
  License as published by the Free Software Foundation; either
  version 2.1 of the License, or (at your option) any later version.

  Csound is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public
  License along with Csound; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
  02111-1307 USA
*/
#include <plugin.h>
#include <algorithm>
#include <cmath>

static inline MYFLT frac(MYFLT f) { return std::modf(f,&f); }

/** i-time, k-rate operator
    kout[] op kin[]
 */
template<MYFLT (*op)(MYFLT)>
struct ArrayOp : csnd::Plugin<1, 1> {  
  int process(csnd::myfltvec &out,
	      csnd::myfltvec &in) {
    std::transform(in.begin(), in.end(), out.begin(),
                   [](MYFLT f) { return op(f); });
    return OK;
  }
  
  int init() {
    csnd::myfltvec &out = outargs.myfltvec_data(0);
    csnd:: myfltvec &in = inargs.myfltvec_data(0);
    out.init(csound,in.len());
    return process(out, in);
  }

  int kperf() {
    return process(outargs.myfltvec_data(0),
		   inargs.myfltvec_data(0));;
  }
};

/** i-time, k-rate binary operator
    kout[] op kin1[], kin2[]
 */
template<MYFLT (*bop)(MYFLT, MYFLT)>
struct ArrayOp2 : csnd::Plugin<1, 2> {
  int init() {
    csnd::myfltvec &out = outargs.myfltvec_data(0);
    csnd::myfltvec &in1 = inargs.myfltvec_data(0);
    csnd::myfltvec &in2 = inargs.myfltvec_data(0);
    if(in2.len() < in1.len())
      return csound->init_error(Str("second input array is too short\n"));
    out.init(csound,in1.len());
    std::transform(in1.begin(), in1.end(), in2.begin(), out.begin(),
                   [](MYFLT f1, MYFLT f2) { return bop(f1,f2); });
    return OK;
  }

  int kperf() {
    csnd::myfltvec &out = outargs.myfltvec_data(0);
    csnd::myfltvec &in1 = inargs.myfltvec_data(0);
    csnd::myfltvec &in2 = inargs.myfltvec_data(0);
    std::transform(in1.begin(), in1.end(), in2.begin(), out.begin(),
                   [](MYFLT f1, MYFLT f2) { return bop(f1,f2); });

    return OK;
  }
};

void csnd::on_load(Csound *csound) {
  csnd::plugin<ArrayOp<std::ceil>>(csound, "ceil", "i[]", "i[]", csnd::thread::i);
  csnd::plugin<ArrayOp<std::ceil>>(csound, "ceil", "k[]", "k[]", csnd::thread::i);
  csnd::plugin<ArrayOp<std::floor>>(csound, "floor", "i[]", "i[]", csnd::thread::i);
  csnd::plugin<ArrayOp<std::floor>>(csound, "floor", "k[]", "k[]", csnd::thread::i);
  csnd::plugin<ArrayOp<std::round>>(csound, "round", "i[]", "i[]", csnd::thread::i);
  csnd::plugin<ArrayOp<std::round>>(csound, "round", "k[]", "k[]", csnd::thread::i);
  csnd::plugin<ArrayOp<std::trunc>>(csound, "int", "i[]", "i[]", csnd::thread::i);
  csnd::plugin<ArrayOp<std::trunc>>(csound, "int", "k[]", "k[]", csnd::thread::i);
  csnd::plugin<ArrayOp<frac>>(csound, "frac", "i[]", "i[]", csnd::thread::i);
  csnd::plugin<ArrayOp<frac>>(csound, "frac", "k[]", "k[]", csnd::thread::i);
  csnd::plugin<ArrayOp<std::exp2>>(csound, "powoftwo", "i[]", "i[]", csnd::thread::i);
  csnd::plugin<ArrayOp<std::exp2>>(csound, "powoftwo", "k[]", "k[]", csnd::thread::i);
  csnd::plugin<ArrayOp<std::fabs>>(csound, "abs", "i[]", "i[]", csnd::thread::i);
  csnd::plugin<ArrayOp<std::fabs>>(csound, "abs", "k[]", "k[]", csnd::thread::i);
  csnd::plugin<ArrayOp<std::fabs>>(csound, "abs", "i[]", "i[]", csnd::thread::i);
  csnd::plugin<ArrayOp<std::fabs>>(csound, "abs", "k[]", "k[]", csnd::thread::i);
  csnd::plugin<ArrayOp<std::log10>>(csound, "log2", "i[]", "i[]", csnd::thread::i);
  csnd::plugin<ArrayOp<std::log10>>(csound, "log2", "k[]", "k[]", csnd::thread::i);
  csnd::plugin<ArrayOp<std::log10>>(csound, "log10", "i[]", "i[]", csnd::thread::i);
  csnd::plugin<ArrayOp<std::log10>>(csound, "log10", "k[]", "k[]", csnd::thread::i);
  csnd::plugin<ArrayOp<std::log>>(csound, "log", "i[]", "i[]", csnd::thread::i);
  csnd::plugin<ArrayOp<std::log>>(csound, "log", "k[]", "k[]", csnd::thread::i);
  csnd::plugin<ArrayOp<std::exp>>(csound, "exp", "i[]", "i[]", csnd::thread::i);
  csnd::plugin<ArrayOp<std::exp>>(csound, "exp", "k[]", "k[]", csnd::thread::i);
  csnd::plugin<ArrayOp<std::sqrt>>(csound, "sqrt", "i[]", "i[]", csnd::thread::i);
  csnd::plugin<ArrayOp<std::sqrt>>(csound, "sqrt", "k[]", "k[]", csnd::thread::ik);
  csnd::plugin<ArrayOp<std::cos>>(csound, "cos", "i[]", "i[]", csnd::thread::i);
  csnd::plugin<ArrayOp<std::cos>>(csound, "cos", "k[]", "k[]", csnd::thread::ik);
  csnd::plugin<ArrayOp<std::sin>>(csound, "sin", "i[]", "i[]", csnd::thread::i);
  csnd::plugin<ArrayOp<std::sin>>(csound, "sin", "k[]", "k[]", csnd::thread::ik);
  csnd::plugin<ArrayOp<std::tan>>(csound, "tan", "i[]", "i[]", csnd::thread::i);
  csnd::plugin<ArrayOp<std::tan>>(csound, "tan", "k[]", "k[]", csnd::thread::ik);
  csnd::plugin<ArrayOp<std::acos>>(csound, "cosinv", "i[]", "i[]", csnd::thread::i);
  csnd::plugin<ArrayOp<std::acos>>(csound, "cosinv", "k[]", "k[]", csnd::thread::ik);
  csnd::plugin<ArrayOp<std::asin>>(csound, "sininv", "i[]", "i[]", csnd::thread::i);
  csnd::plugin<ArrayOp<std::asin>>(csound, "sininv", "k[]", "k[]", csnd::thread::ik);
  csnd::plugin<ArrayOp<std::atan>>(csound, "taninv", "i[]", "i[]", csnd::thread::i);
  csnd::plugin<ArrayOp<std::atan>>(csound, "taninv", "k[]", "k[]", csnd::thread::ik);
  csnd::plugin<ArrayOp<std::cosh>>(csound, "cosh", "i[]", "i[]", csnd::thread::i);
  csnd::plugin<ArrayOp<std::cosh>>(csound, "cosh", "k[]", "k[]", csnd::thread::ik);
  csnd::plugin<ArrayOp<std::sinh>>(csound, "sinh", "i[]", "i[]", csnd::thread::i);
  csnd::plugin<ArrayOp<std::sinh>>(csound, "sinh", "k[]", "k[]", csnd::thread::ik);
  csnd::plugin<ArrayOp<std::tanh>>(csound, "tanh", "i[]", "i[]", csnd::thread::i);
  csnd::plugin<ArrayOp<std::tanh>>(csound, "tanh", "k[]", "k[]", csnd::thread::ik);
  csnd::plugin<ArrayOp<std::cbrt>>(csound, "cbrt", "i[]", "i[]", csnd::thread::i);
  csnd::plugin<ArrayOp<std::cbrt>>(csound, "cbrt", "k[]", "k[]", csnd::thread::ik);
  csnd::plugin<ArrayOp2<std::atan2>>(csound, "taninv", "i[]", "i[]i[]", csnd::thread::i);
  csnd::plugin<ArrayOp2<std::atan2>>(csound, "taninv", "k[]", "k[]k[]", csnd::thread::ik);
  csnd::plugin<ArrayOp2<std::pow>>(csound, "pow", "i[]", "i[]i[]", csnd::thread::i);
  csnd::plugin<ArrayOp2<std::pow>>(csound, "pow", "k[]", "k[]k[]", csnd::thread::ik);
  csnd::plugin<ArrayOp2<std::hypot>>(csound, "hypot", "i[]", "i[]i[]", csnd::thread::i);
  csnd::plugin<ArrayOp2<std::hypot>>(csound, "hypot", "k[]", "k[]k[]", csnd::thread::ik);
  csnd::plugin<ArrayOp2<std::fmod>>(csound, "fmod", "i[]", "i[]i[]", csnd::thread::i);
  csnd::plugin<ArrayOp2<std::fmod>>(csound, "fmod", "k[]", "k[]k[]", csnd::thread::ik);
  csnd::plugin<ArrayOp2<std::fmax>>(csound, "fmax", "i[]", "i[]i[]", csnd::thread::i);
  csnd::plugin<ArrayOp2<std::fmax>>(csound, "fmax", "k[]", "k[]k[]", csnd::thread::ik);
  csnd::plugin<ArrayOp2<std::fmin>>(csound, "fmin", "i[]", "i[]i[]", csnd::thread::i);
  csnd::plugin<ArrayOp2<std::fmin>>(csound, "fmin", "k[]", "k[]k[]", csnd::thread::ik);
}
