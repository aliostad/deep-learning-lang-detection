-- -*-sql-*-
--      $Id$ 
--
--    Copyright 2001 X=X Computer Software Trust 
--                  Kangaroo Ground Australia 3097 
--
--
--   This is free software; you can redistribute it and/or modify 
--   it under the terms of the GNU General Public License published by 
--   the Free Software Foundation; either version 2, or (at your option) 
--   any later version. 
--
--   This software is distributed in the hope that it will be useful, 
--   but WITHOUT ANY WARRANTY; without even the implied warranty of 
--   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
--   GNU General Public License for more details. 
--
--   You should have received a copy of the GNU General Public License 
--   along with this software; see the file COPYING.  If not, write to 
--   the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA. 
--
--   Report problems and direct all questions to: 
--
--       Rex McMaster, rmcm@compsoft.com.au 
--
-- Integrity functions and utility functions for invoices and statements
--

--
--
-- PL functions related to cnrt table
--
--
-- PL function to update contract data.
--
drop function cnrt_tr_before();
create function cnrt_tr_before()
returns opaque
as 'DECLARE
      tmp_serv_code serv.serv_code%TYPE;
      tmp_fept fept%ROWTYPE;
      count_other integer;
      count_remaining integer;

    BEGIN
        RAISE NOTICE ''cnrt_tr_before'';
      --
      -- if missing service code, then use a default
      -- 

      if (new.cnrt_serv_code is null) then
        new.cnrt_serv_code := ''-'';
      end if;

      --
      -- load the fee defaults
      -- 

      select fept.*
      into   tmp_fept
      from   fept,patn
      where  patn__sequence = new.cnrt_patn__sequence
      and    fept_serv_code = new.cnrt_serv_code
      and    fept_feet_code = patn_feet_code;

      if not found then
        tmp_fept.fept_amount := 0.00;
      end if;

      --
      -- set some defaults on INSERT
      --

      if ( TG_OP = ''INSERT'' ) then
        if (new.cnrt_amount is null) then
          new.cnrt_amount := tmp_fept.fept_amount;
        end if;
      end if;
      
      -- amount cannot be less then already posted amounts
      if ( new.cnrt_last_date is not null ) then
        if ( TG_OP = ''UPDATE'' ) then
          if ( new.cnrt_amount < (old.cnrt_amount - old.cnrt_balance) ) then
            new.cnrt_amount := old.cnrt_amount - old.cnrt_balance;
          end if;
          -- balance needs to be adjusted if amount is adjusted
          if ( new.cnrt_amount != old.cnrt_amount ) then
            new.cnrt_balance := new.cnrt_balance + ( new.cnrt_amount - old.cnrt_amount );
          end if;  
        end if;
      end if;

      --
      -- No nulls
      --

      if ( new.cnrt_amount is null ) then
        new.cnrt_amount := 0;
      end if;

      if ( new.cnrt_first_installment is null ) then
        new.cnrt_first_installment := 0;
      end if;

      if ( new.cnrt_other_installment is null ) then
        new.cnrt_other_installment := 0;
      end if;

      if ( new.cnrt_balance is null ) then
        new.cnrt_balance := 0;
      end if;

      if ( new.cnrt_start_date is null ) then
        new.cnrt_start_date := ''now''::timestamp;
      end if;

      if ( new.ctrt_period is null ) then
        new.ctrt_period := ''3 months''::interval;
      end if;

      if ( new.cnrt_count is null or new.cnrt_count < 1 ) then
        new.cnrt_count := 1;
      end if;

      --
      -- calculate
      --

      -- other installment count
      count_other := new.cnrt_count - 1;

      -- limit first installment
      if ( new.cnrt_first_installment > new.cnrt_amount ) then
        new.cnrt_first_installment := new.cnrt_amount;
      end if;

      -- if single payment
      if ( new.cnrt_count = 1 ) then
        new.cnrt_first_installment := new.cnrt_amount;
      else
        if ( new.cnrt_first_installment = 0 ) then
          new.cnrt_first_installment = new.cnrt_amount / new.cnrt_count;
        end if;
      end if;

      -- other payments
      new.cnrt_other_installment := new.cnrt_amount - new.cnrt_first_installment;
      if ( count_other > 1 ) then
        new.cnrt_other_installment := new.cnrt_other_installment / count_other;
      end if;

      
      --
      -- If this appears to be a new contract, then setup default values
      --

      if ( new.cnrt_last_date is null ) then
        new.cnrt_balance := new.cnrt_amount;
        count_remaining := new.cnrt_count;
      else
        count_remaining := round(new.cnrt_balance / new.cnrt_other_installment);
      end if;

      -- recalculate the end date
      new.cnrt_end_date := new.cnrt_last_date + ( count_remaining * new.ctrt_period );

    return new;
    END;'
    LANGUAGE 'plpgsql';

drop trigger cnrt_tr_before on cnrt;
create trigger cnrt_tr_before before insert or update
    on cnrt for each row
    execute procedure cnrt_tr_before();


