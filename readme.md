# Digital Verification Diploma – UVM & SystemVerilog Projects

This repository contains my completed projects and assignments from the **Digital Verification Diploma** by Kareem Wassem. The projects focus on **advanced verification methodologies**, **UVM-based testbench development**, and **functional coverage-driven verification** using **SystemVerilog** and the **Universal Verification Methodology (UVM)**.

## 📌 Projects

### 1. ALU Verification using UVM
- Developed a full UVM testbench for a custom **Arithmetic and Logic Unit (ALU)**.
- Implemented reusable components: **sequencer**, **driver**, **monitor**, **scoreboard**, and **coverage collector**.
- Created constrained-random sequences to exhaustively verify all ALU operations (add, subtract, AND, OR, XOR, shift, etc.).
- Achieved **100% functional coverage** and validated correctness through scoreboard-based comparison.

### 2. SPI Multi-Slave System Verification using UVM
- Verified the **Multi-Slave SPI Master** (from the Digital IC Design Diploma) using a scalable UVM environment.
- Modeled both SPI slaves as **UVM agents** with configurable modes (active/passive).
- Implemented **transaction-level modeling (TLM)** for efficient communication between components.
- Verified protocol compliance, FIFO integration, and error scenarios (e.g., clock polarity mismatches, timing violations).

### 3. Asynchronous FIFO Verification using SystemVerilog
- Built a **SystemVerilog-based verification environment** for a dual-clock (asynchronous) FIFO.
- Verified critical behaviors: **full/empty flags**, **gray-coded pointers**, **clock domain crossing (CDC)** safety.
- Used **assertions (SVA)** to check protocol correctness and data integrity across clock domains.
- Developed directed and random tests to stress FIFO under various read/write rate conditions.

## 🛠 Tools & Technologies
- **Languages:** SystemVerilog, UVM
- **Simulation & Debugging:** QuestaSim, VCS (Synopsys), Verdi
- **Coverage & Analysis:** Functional coverage, code coverage (line, toggle, FSM)
- **Methodology:** UVM 1.2, constrained-random verification, coverage-driven verification (CDV)

## 📧 Contact
Feel free to connect on [LinkedIn](https://www.linkedin.com/in/yousef-ahmed-971a60361) or email me at **Almazghony@gmail.com**.