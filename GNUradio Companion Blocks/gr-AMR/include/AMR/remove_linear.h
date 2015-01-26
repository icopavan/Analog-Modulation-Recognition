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


#ifndef INCLUDED_AMR_REMOVE_LINEAR_H
#define INCLUDED_AMR_REMOVE_LINEAR_H

#include <AMR/api.h>
#include <gnuradio/sync_block.h>

namespace gr {
  namespace AMR {

    /*!
     * \brief <+description of block+>
     * \ingroup AMR
     *
     */
    class AMR_API remove_linear : virtual public gr::sync_block
    {
     public:
      typedef boost::shared_ptr<remove_linear> sptr;

      /*!
       * \brief Return a shared_ptr to a new instance of AMR::remove_linear.
       *
       * To avoid accidental use of raw pointers, AMR::remove_linear's
       * constructor is in a private implementation
       * class. AMR::remove_linear::make is the public interface for
       * creating new instances.
       */
      static sptr make(int vlen);
    };

  } // namespace AMR
} // namespace gr

#endif /* INCLUDED_AMR_REMOVE_LINEAR_H */

