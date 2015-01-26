/* -*- c++ -*- */

#define AMR_API

%include "gnuradio.i"			// the common stuff

//load generated python docstrings
%include "AMR_swig_doc.i"

%{
#include "AMR/phase_unwrap.h"
#include "AMR/carrier.h"
#include "AMR/remove_linear.h"
#include "AMR/std_dev.h"
%}



%include "AMR/phase_unwrap.h"
GR_SWIG_BLOCK_MAGIC2(AMR, phase_unwrap);

%include "AMR/carrier.h"
GR_SWIG_BLOCK_MAGIC2(AMR, carrier);

%include "AMR/remove_linear.h"
GR_SWIG_BLOCK_MAGIC2(AMR, remove_linear);
%include "AMR/std_dev.h"
GR_SWIG_BLOCK_MAGIC2(AMR, std_dev);
