/* -*- c++ -*- */
/* 
 * Copyright 2015 <+YOU OR YOUR COMPANY+>.
 * 
 * This is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3, or (at your option)
 * any later version.
 * 
 * This software is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this software; see the file COPYING.  If not, write to
 * the Free Software Foundation, Inc., 51 Franklin Street,
 * Boston, MA 02110-1301, USA.
 */

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include <gnuradio/io_signature.h>
#include "carrier_impl.h"

namespace gr {
  namespace AMR {

    carrier::sptr
    carrier::make(int vlen)
    {
      return gnuradio::get_initial_sptr
        (new carrier_impl(vlen));
    }

    /*
     * The private constructor
     */
    carrier_impl::carrier_impl(int vlen)
      : gr::sync_block("carrier",
              gr::io_signature::make(1, 1, sizeof(float)*vlen),
              gr::io_signature::make2(2, 2, sizeof(int), sizeof(float)*vlen)),
        p_vlen(vlen)
    {
        set_max_noutput_items(1);
    }

    /*
     * Our virtual destructor.
     */
    carrier_impl::~carrier_impl()
    {
    }

    int
    carrier_impl::work(int noutput_items,
			  gr_vector_const_void_star &input_items,
			  gr_vector_void_star &output_items)
    {
        const float *fft_in = (const float *) input_items[0];
        float *gamma_max_out = (float *) output_items[1];
        int *Nc_out = (int *) output_items[0];

        float max = 0;
        float Nc = 0;
        for (int i = 1; i < p_vlen/2; i++)
        {
            if (fft_in[i] > max)
            {
                max = fft_in[i];
                Nc = i;
            }
        }

        max = max * max;
        for (int i = 0; i < p_vlen; i++)
        {
            gamma_max_out[i] = max;
        }

        *Nc_out = Nc;

        // Tell runtime system how many output items we produced.
        return noutput_items;
    }

  } /* namespace AMR */
} /* namespace gr */

