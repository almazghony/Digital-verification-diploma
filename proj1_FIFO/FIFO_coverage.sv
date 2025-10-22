package coverage_pkg;
import transaction_pkg::*;

    class FIFO_coverage;
        FIFO_transaction F_cvg_txn;

        covergroup FIFO_cvg;
            cp_wr_en: coverpoint F_cvg_txn.wr_en;
            cp_rd_en: coverpoint F_cvg_txn.rd_en;
            cp_full: coverpoint F_cvg_txn.full;
            cp_empty: coverpoint F_cvg_txn.empty;
            cp_almostempty: coverpoint F_cvg_txn.almostempty;
            cp_almostfull: coverpoint F_cvg_txn.almostfull;
            cp_overflow: coverpoint F_cvg_txn.overflow;
            cp_underflow: coverpoint F_cvg_txn.underflow;
            cp_wr_ack: coverpoint F_cvg_txn.wr_ack;

            c1: cross cp_wr_en, cp_rd_en, cp_full{
                ignore_bins b1_full = binsof(cp_wr_en) intersect {1}
                && binsof(cp_rd_en) intersect {1}
                && binsof(cp_full) intersect {1};

                ignore_bins b2_full = binsof(cp_wr_en) intersect {0}
                && binsof(cp_rd_en) intersect {1}
                && binsof(cp_full) intersect {1};
            }
            c2: cross cp_wr_en, cp_rd_en, cp_empty;
            c3: cross cp_wr_en, cp_rd_en, cp_almostfull;
            c4: cross cp_wr_en, cp_rd_en, cp_almostempty;
            c5: cross cp_wr_en, cp_rd_en, cp_overflow{
                ignore_bins b1_overflow = binsof(cp_wr_en) intersect {0}
                && binsof(cp_rd_en) intersect {1}
                && binsof(cp_overflow) intersect {1};
            
                ignore_bins b2_overflow = binsof(cp_wr_en) intersect {0}
                && binsof(cp_rd_en) intersect {0}
                && binsof(cp_overflow) intersect {1};
            }
            c6: cross cp_wr_en, cp_rd_en, cp_underflow{
                ignore_bins b1_underflow = binsof(cp_wr_en) intersect {1}
                && binsof(cp_rd_en) intersect {0}
                && binsof(cp_underflow) intersect {1};
          
                ignore_bins b2_underflow = binsof(cp_wr_en) intersect {0}
                && binsof(cp_rd_en) intersect {0}
                && binsof(cp_underflow) intersect {1};
            }
            c7: cross cp_wr_en, cp_rd_en, cp_wr_ack{
                ignore_bins b1_full = binsof(cp_wr_en) intersect {0}
                && binsof(cp_wr_ack) intersect {1}
                && binsof(cp_wr_ack) intersect {1};
  
                ignore_bins b2_full = binsof(cp_wr_en) intersect {0}
                && binsof(cp_wr_ack) intersect {0}
                && binsof(cp_wr_ack) intersect {1};
            }
        endgroup

        function void sample_data(FIFO_transaction F_txn);
            F_cvg_txn = F_txn;
            FIFO_cvg.sample();
        endfunction

        function new();
            FIFO_cvg = new();
        endfunction
    endclass
endpackage

