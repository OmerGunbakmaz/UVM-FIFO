# UVM FIFO Verification

UVM testbench for a synchronous FIFO (DEPTH=8, WIDTH=8). Internship learning project.

> This is a supervised internship learning project that will be presented, so no vibe coding was used.

**Run it online:** [EDA Playground](https://edaplayground.com/x/DGuA) (Cadence Xcelium, UVM 1.2)
Select a test with `+UVM_TESTNAME=<test>` in Run options.

## Architecture

```mermaid
flowchart LR
    subgraph TEST["fifo_*_test"]
        SEQ["sequence"]
        subgraph ENV["fifo_env"]
            subgraph AGENT["fifo_agent"]
                SQR["sequencer"] --> DRV["driver"]
                MON["monitor"]
            end
            SCB["scoreboard<br/>(reference queue)"]
            COV["coverage<br/>(covergroup)"]
        end
    end

    subgraph TOP["tb_top"]
        IF["fifo_if<br/>(drv_cb / mon_cb)"]
        DUT["fifo (DUT)"]
        IF <--> DUT
    end

    SEQ --> SQR
    DRV -- "drv_cb" --> IF
    IF -- "mon_cb" --> MON
    MON -- "analysis port" --> SCB
    MON -- "analysis port" --> COV

    classDef comp fill:#ffffff,stroke:#475569,color:#1e293b
    classDef dut fill:#fef3c7,stroke:#d97706,color:#1e293b
    class SEQ,SQR,DRV,MON,SCB,COV,IF comp
    class DUT dut

    style TEST fill:#eef2ff,stroke:#6366f1,color:#1e293b
    style ENV fill:#ecfdf5,stroke:#10b981,color:#1e293b
    style AGENT fill:#fff7ed,stroke:#f97316,color:#1e293b
    style TOP fill:#f1f5f9,stroke:#64748b,color:#1e293b
```

## Results

| Test | Functional coverage | Scoreboard |
|---|---|---|
| fifo_basic_test | 58.1% | 5/5 pass |
| fifo_fill_drain_test | 90.3% | 28/28 pass |
| fifo_rw_test | 98.1% | 51/51 pass |
| fifo_random_test (seed 1) | 100% | 976/976 pass |
| fifo_override_test (seed 1) | 98.1% | 832/832 pass |

## Bug injection

The RTL contains three intentional bugs behind defines. Add one to Compile options (e.g. `+define+BUG_FULL_OFF_BY_ONE`) and run `fifo_fill_drain_test`; the scoreboard should report `UVM_ERROR`s.

| Define | Bug | Caught by |
|---|---|---|
| `BUG_FULL_OFF_BY_ONE` | `full` asserts at 7 entries | flag check |
| `BUG_WRITE_WHEN_FULL` | write accepted when full, overwrites oldest entry | flag check, data compare |
| `BUG_PTR_WRAP` | write pointer wraps one entry early | data compare |