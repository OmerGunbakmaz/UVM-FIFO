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

    classDef comp fill:#4b5563,stroke:#9ca3af,color:#f3f4f6
    classDef dut fill:#1f2937,stroke:#cbd5e1,stroke-width:2px,color:#f9fafb
    class SEQ,SQR,DRV,MON,SCB,COV,IF comp
    class DUT dut

    style TEST fill:#2b2f36,stroke:#6b7280,color:#e5e7eb
    style ENV fill:#343a42,stroke:#8b949e,color:#e5e7eb
    style AGENT fill:#3f4650,stroke:#9ca3af,color:#e5e7eb
    style TOP fill:#2b2f36,stroke:#6b7280,color:#e5e7eb
```

## Design notes

- **Monitor** publishes every cycle one cycle late, because `rdata` is registered.
- **Scoreboard** decides accept/reject with its own model, not the DUT flags, so flag bugs are caught.
- **Tests** share one base test; each test picks its sequence with a factory override.

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