////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: UVM Example
// 
////////////////////////////////////////////////////////////////////////////////
package sr_env_pkg;
  import sr_agent_pkg::*;
  import sr_scoreboard_pkg::*;
  import sr_cov_collector_pkg::*;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  class sr_env extends uvm_env;
      `uvm_component_utils(sr_env);
        sr_agent agent;
        sr_scoreboard sb;
        sr_cov_collector cov;

      function new(string name = "sr_env", uvm_component parent);
          super.new(name, parent);
      endfunction

      function void build_phase(uvm_phase phase);
          super.build_phase(phase);
          agent = sr_agent::type_id::create("agent", this);
          sb = sr_scoreboard::type_id::create("sb", this);
          cov = sr_cov_collector::type_id::create("cov", this);
      endfunction

      function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            agent.agent_ap.connect(sb.sb_export);
            agent.agent_ap.connect(cov.cov_export);
      endfunction
  endclass
endpackage

