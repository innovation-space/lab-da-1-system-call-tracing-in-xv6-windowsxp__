#!/usr/bin/env python3
"""
generate_spinlock_race_docs.py
Generates the Master Word Document (.docx) for the xv6 Multiprocessor Race Condition
and Spinlock Synchronization Demonstration.
Matches the exact visual styling, structure, and 4-box step layout of XV6_PROCESS_LIFECYCLE_PRESENTATION.docx.
Team: WindowsXP
Presenters:
  Participant 1: Tejas Deshpande (24BKT0145)
  Participant 2: Vidit Agrawal (24BKT0139)
  Participant 3: Devarsh Patel (24BCT0267)
"""

import os
import shutil
import docx
from docx.shared import Inches, Pt, RGBColor
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.enum.table import WD_TABLE_ALIGNMENT
from docx.oxml import parse_xml
from docx.oxml.ns import nsdecls

# --- Color Definitions Matching Reference Template ---
COLOR_NAVY = RGBColor(29, 91, 150)        # #1D5B96
COLOR_DARK_BLUE = RGBColor(15, 41, 74)    # #0F294A
COLOR_DARK_SLATE = RGBColor(15, 23, 42)   # #0F172A
COLOR_TEXT_MAIN = RGBColor(30, 41, 59)    # #1E293B
COLOR_MUTED_GRAY = RGBColor(148, 163, 184)# #94A3B8
COLOR_AMBER_DARK = RGBColor(146, 64, 14)  # #92400E
COLOR_CYAN_LIGHT = RGBColor(56, 189, 248) # #38BDF8
COLOR_CODE_TEXT = RGBColor(226, 232, 240) # #E2E8F0
COLOR_DANGER_TEXT = RGBColor(153, 27, 27) # #991B1B
COLOR_SUCCESS_TEXT = RGBColor(22, 101, 52)# #166534

HEX_NAVY = "1D5B96"
HEX_DARK_BLUE = "0F294A"
HEX_BORDER = "CBD5E1"

def set_cell_background(cell, hex_color):
    tcPr = cell._tc.get_or_add_tcPr()
    shd = parse_xml(f'<w:shd {nsdecls("w")} w:fill="{hex_color}"/>')
    tcPr.append(shd)

def set_cell_margins(cell, top=80, bottom=80, left=120, right=120):
    tcPr = cell._tc.get_or_add_tcPr()
    tcMar = parse_xml(f'<w:tcMar {nsdecls("w")}><w:top w:w="{top}" w:type="dxa"/><w:bottom w:w="{bottom}" w:type="dxa"/><w:left w:w="{left}" w:type="dxa"/><w:right w:w="{right}" w:type="dxa"/></w:tcMar>')
    tcPr.append(tcMar)

def set_cell_border(cell, **kwargs):
    tcPr = cell._tc.get_or_add_tcPr()
    tcBorders = parse_xml(f'<w:tcBorders {nsdecls("w")}/>')
    for edge in ('top', 'left', 'bottom', 'right', 'insideH', 'insideV'):
        edge_data = kwargs.get(edge)
        if edge_data:
            b_xml = f'<w:{edge} {nsdecls("w")} w:val="{edge_data.get("val", "single")}" w:sz="{edge_data.get("sz", "4")}" w:space="0" w:color="{edge_data.get("color", "auto")}"/>'
        else:
            b_xml = f'<w:{edge} {nsdecls("w")} w:val="none"/>'
        tcBorders.append(parse_xml(b_xml))
    tcPr.append(tcBorders)

def add_heading_1(doc, text):
    h = doc.add_paragraph()
    h.paragraph_format.space_before = Pt(18)
    h.paragraph_format.space_after = Pt(4)
    h.paragraph_format.keep_with_next = True
    run = h.add_run(text)
    run.font.name = "Arial"
    run.font.size = Pt(14)
    run.font.bold = True
    run.font.color.rgb = COLOR_DARK_BLUE
    return h

def add_heading_2(doc, text):
    h = doc.add_paragraph()
    h.paragraph_format.space_before = Pt(12)
    h.paragraph_format.space_after = Pt(3)
    h.paragraph_format.keep_with_next = True
    run = h.add_run(text)
    run.font.name = "Arial"
    run.font.size = Pt(11.5)
    run.font.bold = True
    run.font.color.rgb = COLOR_NAVY
    return h

def add_heading_3(doc, text):
    h = doc.add_paragraph()
    h.paragraph_format.space_before = Pt(10)
    h.paragraph_format.space_after = Pt(3)
    h.paragraph_format.keep_with_next = True
    run = h.add_run(text)
    run.font.name = "Arial"
    run.font.size = Pt(11)
    run.font.bold = True
    run.font.color.rgb = COLOR_NAVY
    return h

def add_body_paragraph(doc, text, bold_prefix=""):
    p = doc.add_paragraph()
    p.paragraph_format.space_before = Pt(2)
    p.paragraph_format.space_after = Pt(3)
    p.paragraph_format.line_spacing = 1.15
    if bold_prefix:
        r_pre = p.add_run(bold_prefix)
        r_pre.font.name = "Arial"
        r_pre.font.size = Pt(9.5)
        r_pre.font.bold = True
        r_pre.font.color.rgb = COLOR_DARK_BLUE
    r = p.add_run(text)
    r.font.name = "Arial"
    r.font.size = Pt(9.5)
    r.font.color.rgb = COLOR_TEXT_MAIN
    return p

# --- 4 Standard Step Box Helpers Matching Template ---

def add_command_box(doc, terminal_label, command_text):
    tbl = doc.add_table(rows=1, cols=1)
    tbl.alignment = WD_TABLE_ALIGNMENT.CENTER
    tbl.autofit = False
    cell = tbl.cell(0, 0)
    cell.width = Inches(7.0)
    set_cell_background(cell, "F1F5F9")
    set_cell_margins(cell, top=70, bottom=70, left=120, right=120)
    
    p = cell.paragraphs[0]
    p.paragraph_format.space_before = Pt(1)
    p.paragraph_format.space_after = Pt(2)
    r_lbl = p.add_run(f"📋 {terminal_label} — SINGLE COMMAND TO EXECUTE:\n")
    r_lbl.font.name = "Arial"
    r_lbl.font.size = Pt(9.0)
    r_lbl.font.bold = True
    r_lbl.font.color.rgb = COLOR_NAVY
    
    r_cmd = p.add_run(command_text)
    r_cmd.font.name = "Consolas"
    r_cmd.font.size = Pt(9.0)
    r_cmd.font.bold = True
    r_cmd.font.color.rgb = COLOR_DARK_SLATE
    doc.add_paragraph().paragraph_format.space_after = Pt(2)

def add_output_box(doc, output_label, output_text):
    tbl = doc.add_table(rows=1, cols=1)
    tbl.alignment = WD_TABLE_ALIGNMENT.CENTER
    tbl.autofit = False
    cell = tbl.cell(0, 0)
    cell.width = Inches(7.0)
    set_cell_background(cell, "0F172A")
    set_cell_margins(cell, top=70, bottom=70, left=120, right=120)
    
    p = cell.paragraphs[0]
    p.paragraph_format.space_before = Pt(1)
    p.paragraph_format.space_after = Pt(2)
    r_lbl = p.add_run(f"🖥️ {output_label}:\n")
    r_lbl.font.name = "Arial"
    r_lbl.font.size = Pt(8.5)
    r_lbl.font.bold = True
    r_lbl.font.color.rgb = COLOR_MUTED_GRAY
    
    r_out = p.add_run(output_text)
    r_out.font.name = "Consolas"
    r_out.font.size = Pt(8.0)
    r_out.font.color.rgb = COLOR_CODE_TEXT
    doc.add_paragraph().paragraph_format.space_after = Pt(2)

def add_say_box(doc, speaker_label, dialogue_text):
    tbl = doc.add_table(rows=1, cols=1)
    tbl.alignment = WD_TABLE_ALIGNMENT.CENTER
    tbl.autofit = False
    cell = tbl.cell(0, 0)
    cell.width = Inches(7.0)
    set_cell_background(cell, "FEF3C7")
    set_cell_margins(cell, top=80, bottom=80, left=130, right=130)
    
    p = cell.paragraphs[0]
    p.paragraph_format.space_before = Pt(1)
    p.paragraph_format.space_after = Pt(3)
    r_lbl = p.add_run(f"🗣️ WHAT TO SAY WHILE/AFTER EXECUTING ({speaker_label}):\n")
    r_lbl.font.name = "Arial"
    r_lbl.font.size = Pt(9.5)
    r_lbl.font.bold = True
    r_lbl.font.color.rgb = COLOR_AMBER_DARK
    
    r_say = p.add_run(f'"{dialogue_text}"')
    r_say.font.name = "Georgia"
    r_say.font.size = Pt(9.0)
    r_say.font.italic = True
    r_say.font.color.rgb = COLOR_TEXT_MAIN
    doc.add_paragraph().paragraph_format.space_after = Pt(2)

def add_under_the_hood_box(doc, explanation_text):
    tbl = doc.add_table(rows=1, cols=1)
    tbl.alignment = WD_TABLE_ALIGNMENT.CENTER
    tbl.autofit = False
    cell = tbl.cell(0, 0)
    cell.width = Inches(7.0)
    set_cell_background(cell, "EFF6FF")
    set_cell_margins(cell, top=70, bottom=70, left=120, right=120)
    
    p = cell.paragraphs[0]
    p.paragraph_format.space_before = Pt(1)
    p.paragraph_format.space_after = Pt(2)
    r_lbl = p.add_run("⚙️ UNDER THE HOOD (KERNEL & HARDWARE STATE):\n")
    r_lbl.font.name = "Arial"
    r_lbl.font.size = Pt(9.0)
    r_lbl.font.bold = True
    r_lbl.font.color.rgb = COLOR_NAVY
    
    r_exp = p.add_run(explanation_text)
    r_exp.font.name = "Arial"
    r_exp.font.size = Pt(8.5)
    r_exp.font.color.rgb = COLOR_TEXT_MAIN
    doc.add_paragraph().paragraph_format.space_after = Pt(6)

def add_full_step(doc, step_num, step_title, terminal_label, command_text, output_label, output_text, speaker_label, dialogue_text, under_the_hood_text):
    add_heading_3(doc, f"Step {step_num}: {step_title}")
    add_command_box(doc, terminal_label, command_text)
    add_output_box(doc, output_label, output_text)
    add_say_box(doc, speaker_label, dialogue_text)
    add_under_the_hood_box(doc, under_the_hood_text)

def build_document():
    doc = docx.Document()
    
    # Configure Margins: 0.75 inch (standard template width 7.0 inch body)
    sections = doc.sections
    for section in sections:
        section.top_margin = Inches(0.75)
        section.bottom_margin = Inches(0.75)
        section.left_margin = Inches(0.75)
        section.right_margin = Inches(0.75)

    # ----------------------------------------------------
    # DOCUMENT HEADER / TITLE
    # ----------------------------------------------------
    p_title = doc.add_paragraph()
    p_title.paragraph_format.space_before = Pt(10)
    p_title.paragraph_format.space_after = Pt(2)
    p_title.paragraph_format.alignment = WD_ALIGN_PARAGRAPH.CENTER
    r = p_title.add_run("xv6 Multiprocessor Race Condition & Spinlock Synchronization Trace")
    r.font.name = "Arial"
    r.font.size = Pt(17)
    r.font.bold = True
    r.font.color.rgb = COLOR_DARK_BLUE

    p_sub = doc.add_paragraph()
    p_sub.paragraph_format.space_before = Pt(1)
    p_sub.paragraph_format.space_after = Pt(6)
    p_sub.paragraph_format.alignment = WD_ALIGN_PARAGRAPH.CENTER
    r = p_sub.add_run("Complete Synchronized Line-by-Line Presentation Manual & Viva Defense Guide\n1 Command ➔ 1 Screen Output ➔ 1 Exact Spoken Script ➔ 1 Examiner Defense Point")
    r.font.name = "Arial"
    r.font.size = Pt(10)
    r.font.color.rgb = COLOR_NAVY

    # Table 0: Critical Recovery Box (Red callout)
    tbl_rec = doc.add_table(rows=1, cols=1)
    tbl_rec.alignment = WD_TABLE_ALIGNMENT.CENTER
    tbl_rec.autofit = False
    c_rec = tbl_rec.cell(0, 0)
    c_rec.width = Inches(7.0)
    set_cell_background(c_rec, "FEE2E2")
    set_cell_margins(c_rec, top=80, bottom=80, left=120, right=120)
    
    p_rec = c_rec.paragraphs[0]
    p_rec.paragraph_format.space_before = Pt(1)
    p_rec.paragraph_format.space_after = Pt(2)
    r = p_rec.add_run("🚨 CRITICAL RECOVERY & EXECUTION RULES:\n")
    r.font.name = "Arial"
    r.font.size = Pt(9.5)
    r.font.bold = True
    r.font.color.rgb = COLOR_DANGER_TEXT
    
    r_rules = p_rec.add_run(
        "1. If GDB ever displays 'No symbol table is loaded', simply type: file kernel/kernel\n"
        "2. Always ensure QEMU runs with CPUS=2 (or higher) to enable true symmetric multiprocessing.\n"
        "3. Keep Terminal 1 on Left (QEMU xv6 Shell) and Terminal 2 on Right (Host Shell / GDB Debugger).\n"
        "4. Team WindowsXP Presenter Sequence: Participant 1 = Tejas, Participant 2 = Vidit, Participant 3 = Devarsh."
    )
    r_rules.font.name = "Arial"
    r_rules.font.size = Pt(8.5)
    r_rules.font.color.rgb = COLOR_TEXT_MAIN

    doc.add_paragraph().paragraph_format.space_after = Pt(6)

    # Table 1: Presenter Roster Table (Dark Blue Header)
    tbl_roster = doc.add_table(rows=4, cols=3)
    tbl_roster.alignment = WD_TABLE_ALIGNMENT.CENTER
    tbl_roster.autofit = False
    
    r_headers = ["Presenter & Team", "Core Technical Topic", "Key Functions, Hardware Instructions & State"]
    r_widths = [Inches(1.8), Inches(2.5), Inches(2.7)]
    
    for c_idx, h_text in enumerate(r_headers):
        cell = tbl_roster.cell(0, c_idx)
        cell.width = r_widths[c_idx]
        set_cell_background(cell, HEX_DARK_BLUE)
        set_cell_margins(cell, top=70, bottom=70, left=90, right=90)
        p = cell.paragraphs[0]; p.paragraph_format.space_before = Pt(1); p.paragraph_format.space_after = Pt(1)
        r = p.add_run(h_text); r.font.name = "Arial"; r.font.size = Pt(8.5); r.font.bold = True; r.font.color.rgb = RGBColor(255, 255, 255)

    roster_rows = [
        ("Participant 1: Tejas Deshpande\n(Reg: 24BKT0145)\nTeam WindowsXP",
         "Concurrency Foundations, Multiprocessor Race Windows & Ground Zero Live Unlocked Race",
         "struct shared_resource, counter++, race_increment(iters, 0), racetest\nNon-atomic Read-Modify-Write (lw -> addiw -> sw) -> 75% Lost Updates"),
        
        ("Participant 2: Vidit Agrawal\n(Reg: 24BKT0139)\nTeam WindowsXP",
         "xv6 Spinlock Internals, RISC-V Hardware Atomics (amoswap.w.aq), Memory Fences & GDB",
         "acquire(), release(), struct spinlock (24B with 4B padding hole)\namoswap.w.aq a5, a4, (s1) (Acquire barrier), fence rw,w, sw zero"),
         
        ("Participant 3: Devarsh Patel\n(Reg: 24BCT0267)\nTeam WindowsXP",
         "Nested Interrupt Invariants (push_off/pop_off), Complete Race Elimination & Final Benchmarks",
         "push_off(), pop_off(), mycpu()->noff, mycpu()->intena, sstatus SIE\nracetest locked -> 100% Mutual Exclusion (4000/4000, 0 Lost Updates)")
    ]

    for r_idx, (p_info, p_topic, p_funcs) in enumerate(roster_rows):
        for c_idx, text in enumerate((p_info, p_topic, p_funcs)):
            cell = tbl_roster.cell(r_idx + 1, c_idx)
            cell.width = r_widths[c_idx]
            bg = "F8FAFC" if r_idx % 2 == 0 else "FFFFFF"
            set_cell_background(cell, bg)
            set_cell_margins(cell, top=60, bottom=60, left=90, right=90)
            set_cell_border(cell, bottom=dict(val="single", sz="4", color=HEX_BORDER))
            p = cell.paragraphs[0]; p.paragraph_format.space_before = Pt(1); p.paragraph_format.space_after = Pt(1)
            r = p.add_run(text); r.font.name = "Arial"; r.font.size = Pt(8.0)
            if c_idx == 0:
                r.font.bold = True; r.font.color.rgb = COLOR_NAVY
            else:
                r.font.color.rgb = COLOR_TEXT_MAIN

    doc.add_paragraph().paragraph_format.space_after = Pt(8)

    # ----------------------------------------------------
    # SECTION 0: PRE-PRESENTATION SETUP
    # ----------------------------------------------------
    add_heading_1(doc, "SECTION 0: PRE-PRESENTATION TERMINAL SETUP")
    add_body_paragraph(doc, "Run these preparation commands before calling the professor or starting the presentation.")

    add_heading_3(doc, "Step 0.1: Clean Build Kernel, Filesystem & .gdbinit Configuration")
    add_command_box(
        doc,
        "TERMINAL SETUP (RUN ONCE IN TERMINAL 1)",
        "cd /Users/raffe/Documents/GitHub/lab-da-1-system-call-tracing-in-xv6-windowsxp__\n"
        "export PATH=\"/Library/Developer/CommandLineTools/usr/bin:$PATH\"\n"
        "make clean\n"
        "make -j4 kernel/kernel fs.img .gdbinit"
    )
    add_output_box(
        doc,
        "EXPECTED BUILD OUTPUT",
        "riscv64-unknown-elf-gcc ... -c -o kernel/race.o kernel/race.c\n"
        "riscv64-unknown-elf-gcc ... -c -o user/racetest.o user/racetest.c\n"
        "riscv64-unknown-elf-ld -z max-page-size=4096 -T kernel/kernel.ld -o kernel/kernel ...\n"
        "mkfs/mkfs fs.img README ... user/_racetest\n"
        "nmeta 47 blocks 1953 total 2000"
    )
    add_say_box(
        doc,
        "PARTICIPANT 1 - PREPARATION",
        "We begin by compiling a clean xv6 kernel with our shared resource subsystem and user benchmark binary racetest. Both fs.img and .gdbinit are primed for execution."
    )
    add_under_the_hood_box(
        doc,
        "The Makefile compiles kernel/race.c into kernel/race.o, registers SYS_race_inc, SYS_race_get, and SYS_race_reset, and packs user/_racetest into the root filesystem image."
    )

    doc.add_page_break()

    # ----------------------------------------------------
    # SECTION 1: PARTICIPANT 1 — TEJAS DESHPANDE
    # ----------------------------------------------------
    add_heading_1(doc, "SECTION 1: PARTICIPANT 1 — TEJAS DESHPANDE (24BKT0145)")
    add_heading_2(doc, "Topic: Concurrency Foundations, Multiprocessor Race Windows & Ground Zero Live Unlocked Race")
    add_body_paragraph(doc, "Responsible Functions & Commands: struct shared_resource, race_increment(iters, 0), racetest unlocked, racetest 2 500 0")

    add_say_box(
        doc,
        "PARTICIPANT 1 - OPENING DIALOGUE",
        "Respected Professor and peers, good morning. I am Tejas Deshpande, registration number 24BKT0145, representing team WindowsXP. Today, our team will present a live hardware and kernel demonstration of multiprocessor race conditions on shared kernel data structures in xv6 on RISC-V, and their complete elimination using xv6 spinlocks. When multiple CPUs execute concurrently without locking, instruction interleaving causes lost updates. Consider counter++: at the machine level, it requires a load word, an add immediate word, and a store word. If two cores execute this simultaneously, both read the identical stale value before either stores back. One increment overwrites the other, causing a Lost Update. Let us examine the shared kernel data structure in code."
    )

    add_full_step(
        doc,
        "1.1",
        "Inspect Shared Kernel Data Structure in kernel/race.c",
        "TERMINAL 2 (RIGHT - HOST / EDITOR)",
        "sed -n '13,30p' kernel/race.c",
        "EXPECTED CODE OUTPUT",
        "// Shared kernel data structure subject to concurrent manipulation\n"
        "struct shared_resource {\n"
        "  struct spinlock lock;        // Dedicated xv6 spinlock for mutual exclusion\n"
        "  volatile int counter;        // Shared integer counter\n"
        "  volatile int total_ops;      // Audit tracker for completed increments\n"
        "};\n\n"
        "static struct shared_resource shared_res;\n\n"
        "// Initialize the shared resource and its spinlock\n"
        "void\n"
        "race_init(void)\n"
        "{\n"
        "  initlock(&shared_res.lock, \"race_counter\");\n"
        "  shared_res.counter = 0;\n"
        "  shared_res.total_ops = 0;\n"
        "}",
        "PARTICIPANT 1",
        "In Terminal 2, we inspect kernel/race.c. We define struct shared_resource containing our dedicated spinlock, a volatile counter, and an operation tracker. The volatile keyword informs the compiler that memory may change asynchronously, preventing register caching. We declare static struct shared_resource shared_res in kernel BSS, making it a single global shared memory object accessible to all cores.",
        "shared_res is placed in the global kernel data segment. Every process executing a system call in kernel mode maps this identical physical memory address."
    )

    add_full_step(
        doc,
        "1.2",
        "Inspect Vulnerable Unlocked Critical Section in kernel/race.c",
        "TERMINAL 2 (RIGHT - HOST / EDITOR)",
        "sed -n '71,88p' kernel/race.c",
        "EXPECTED CODE OUTPUT",
        "    } else {\n"
        "      // Unprotected critical section (VULNERABLE TO RACE CONDITIONS)\n"
        "      // Read shared state into local register\n"
        "      volatile int temp = shared_res.counter;\n\n"
        "      // In unlocked mode, preemption/context-switching or core interleaving\n"
        "      // during the vulnerable read-modify-write window causes lost updates.\n"
        "      if ((i % 5) == 0) {\n"
        "        yield();\n"
        "      } else {\n"
        "        for (volatile int d = 0; d < 30; d++)\n"
        "          ;\n"
        "      }\n\n"
        "      // Overwrite shared state with stale computation -> Lost Update occurs\n"
        "      shared_res.counter = temp + 1;\n"
        "      shared_res.total_ops++;\n"
        "    }",
        "PARTICIPANT 1",
        "Notice lines 71 to 88: when use_lock == 0, the critical section is completely unprotected. Process 1 reads temp = shared_res.counter. During the race window, preemption or delays allow Process 2 on CPU 1 to read the same stale value and commit its increments. When Process 1 resumes, it writes its own temp + 1, completely overwriting and wiping out Process 2's updates!",
        "Non-atomic read-modify-write permits concurrent interleaving across hardware harts, violating the atomicity guarantee. (Note: running sed -n '72,86p' isolates lines 72 to 86 ending directly at shared_res.counter = temp + 1;)."
    )

    add_full_step(
        doc,
        "1.3",
        "Inspect User Benchmark Utility in user/racetest.c",
        "TERMINAL 2 (RIGHT - HOST / EDITOR)",
        "sed -n '26,47p' user/racetest.c",
        "EXPECTED CODE OUTPUT",
        "  race_reset();\n\n"
        "  printf(\"Spawning %d concurrent processes across CPUs...\\n\", num_children);\n"
        "  for (int i = 0; i < num_children; i++) {\n"
        "    int pid = fork();\n"
        "    if (pid < 0) {\n"
        "      printf(\"racetest: fork failed on child %d\\n\", i);\n"
        "      exit(1);\n"
        "    }\n"
        "    if (pid == 0) {\n"
        "      // Child process: execute kernel increments concurrently\n"
        "      race_inc(iters, use_lock);\n"
        "      exit(0);\n"
        "    }\n"
        "  }\n\n"
        "  // Parent process: await completion of all concurrent children\n"
        "  for (int i = 0; i < num_children; i++) {\n"
        "    wait(0);\n"
        "  }",
        "PARTICIPANT 1",
        "In user space, racetest.c calls race_reset() to zero the kernel counter, forks multiple child processes that execute race_inc() concurrently, and calls wait(0) before reading the final value with race_get().",
        "When multiple child processes are RUNNABLE, the xv6 scheduler distributes them across available CPU cores (CPUS=2), creating simultaneous parallel execution."
    )

    add_full_step(
        doc,
        "1.4",
        "Launch xv6 with Symmetric Multiprocessing (CPUS=2)",
        "TERMINAL 1 (LEFT - QEMU SHELL)",
        "make CPUS=2 qemu",
        "EXPECTED SCREEN OUTPUT",
        "qemu-system-riscv64 -machine virt -bios none -kernel kernel/kernel -m 128M -smp 2 -nographic -global virtio-mmio.force-legacy=false -drive file=fs.img,if=none,format=raw,id=x0 -device virtio-blk-device,drive=x0,bus=virtio-mmio-bus.0\n\n"
        "xv6 kernel is booting\n\n"
        "hart 1 starting\n"
        "init: starting sh\n"
        "$ ",
        "PARTICIPANT 1",
        "In Terminal 1 on the left, we boot xv6 in QEMU configured with CPUS=2. Notice the line: hart 1 starting. Hart 0 boots the kernel and wakes up Hart 1. Both cores are now running their scheduler loops in parallel.",
        "CPU 0 initializes kernel memory, then sets started = 1 with a memory fence (__atomic_thread_fence), allowing CPU 1 to break out of its spinloop in main.c and enter scheduler()."
    )

    add_full_step(
        doc,
        "1.5",
        "Execute Ground Zero Live Unlocked Race Demonstration",
        "TERMINAL 1 (LEFT - QEMU SHELL)",
        "racetest unlocked",
        "EXPECTED SCREEN OUTPUT",
        "$ racetest unlocked\n\n"
        "############################################################\n"
        "#  xv6 MULTIPROCESSOR RACE CONDITION & SPINLOCK SUITE      #\n"
        "#  Team: WindowsXP | Tejas, Vidit, Devarsh                 #\n"
        "############################################################\n\n"
        "============================================================\n"
        "[RACE CONDITION TEST] Mode: Unlocked (Concurrent Read-Modify-Write)\n"
        "Protection: NONE (Vulnerable to SMP Race Window)\n"
        "Configuration: 4 child processes x 1000 iterations\n"
        "Expected Counter Result: 4000\n"
        "------------------------------------------------------------\n"
        "Spawning 4 concurrent processes across CPUs...\n"
        "Execution Complete. Reading final shared kernel counter...\n"
        "------------------------------------------------------------\n"
        "  >> Expected Value  : 4000\n"
        "  >> Actual Counter  : 1000\n"
        "  >> Lost Updates    : 3000 (75% data loss)\n"
        "------------------------------------------------------------\n"
        "VERDICT: RACE CONDITION CONFIRMED!\n"
        "Interleaved memory access on multi-core CPU caused 3000 lost updates.\n"
        "============================================================",
        "PARTICIPANT 1",
        "Look at the terminal output on the screen! 4 concurrent child processes executed 1,000 kernel increments each. We mathematically expected 4,000. Instead, the actual recorded value is only 1,000! A staggering 3,000 updates were lost—representing 75% data loss due to uncoordinated concurrent memory overwrites! This provides undeniable live proof of a race condition on a shared kernel data structure.",
        "As the 4 processes interleave across cores, processes continuously read stale snapshots of shared_res.counter, resulting in 3 out of every 4 increments being wiped out."
    )

    add_full_step(
        doc,
        "1.6",
        "Execute Parametric 2-Process Collision Test",
        "TERMINAL 1 (LEFT - QEMU SHELL)",
        "racetest 2 500 0",
        "EXPECTED SCREEN OUTPUT",
        "$ racetest 2 500 0\n\n"
        "############################################################\n"
        "#  xv6 MULTIPROCESSOR RACE CONDITION & SPINLOCK SUITE      #\n"
        "#  Team: WindowsXP | Tejas, Vidit, Devarsh                 #\n"
        "############################################################\n\n"
        "============================================================\n"
        "[RACE CONDITION TEST] Mode: Unlocked (Concurrent Read-Modify-Write)\n"
        "Protection: NONE (Vulnerable to SMP Race Window)\n"
        "Configuration: 2 child processes x 500 iterations\n"
        "Expected Counter Result: 1000\n"
        "------------------------------------------------------------\n"
        "Spawning 2 concurrent processes across CPUs...\n"
        "Execution Complete. Reading final shared kernel counter...\n"
        "------------------------------------------------------------\n"
        "  >> Expected Value  : 1000\n"
        "  >> Actual Counter  : 500\n"
        "  >> Lost Updates    : 500 (50% data loss)\n"
        "------------------------------------------------------------\n"
        "VERDICT: RACE CONDITION CONFIRMED!\n"
        "Interleaved memory access on multi-core CPU caused 500 lost updates.\n"
        "============================================================",
        "PARTICIPANT 1",
        "With 2 processes x 500 operations, expected: 1,000; actual: 500—exactly 50% data loss! If this counter had represented a process table entry count or a free memory page list, this silent corruption would crash the operating system. How does an OS eliminate this? Through Mutual Exclusion. I now hand over to Vidit Agrawal for spinlock internals and hardware atomics.",
        "Tejas hands over to Vidit for machine-level disassembly and lock internals."
    )

    doc.add_page_break()

    # ----------------------------------------------------
    # SECTION 2: PARTICIPANT 2 — VIDIT AGRAWAL
    # ----------------------------------------------------
    add_heading_1(doc, "SECTION 2: PARTICIPANT 2 — VIDIT AGRAWAL (24BKT0139)")
    add_heading_2(doc, "Topic: xv6 Spinlock Internals, RISC-V Hardware Atomics (amoswap.w.aq), Memory Fences & GDB Hardware Step-Through")
    add_body_paragraph(doc, "Responsible Functions & Commands: struct spinlock, acquire(), release(), amoswap.w.aq, fence rw,w, GDB disassembly")

    add_say_box(
        doc,
        "PARTICIPANT 2 - OPENING DIALOGUE",
        "Thank you, Tejas. Respected evaluators, I am Vidit Agrawal, registration number 24BKT0139. Software-level flags like if (!locked) locked = 1; fail because that check-and-set sequence can itself be interrupted midway. We need an indivisible hardware guarantee: atomicity. In xv6, the primary mutual exclusion primitive is the spinlock. Let us inspect how xv6 implements spinlocks down to the raw RISC-V assembly and CPU cache coherency."
    )

    add_full_step(
        doc,
        "2.1",
        "Code Walkthrough — struct spinlock Definition",
        "TERMINAL 2 (RIGHT - HOST / EDITOR)",
        "sed -n '1,12p' kernel/spinlock.h",
        "EXPECTED CODE OUTPUT",
        "// Mutual exclusion lock.\n"
        "struct spinlock {\n"
        "  uint locked; // Is the lock held?\n\n"
        "  // For debugging:\n"
        "  char *name;      // Name of lock.\n"
        "  struct cpu *cpu; // The cpu holding the lock.\n"
        "};",
        "PARTICIPANT 2",
        "In kernel/spinlock.h, struct spinlock contains uint locked (0 = free, 1 = held), name for diagnostics, and struct cpu *cpu to track ownership and detect illegal recursive acquisitions.",
        "In-memory representation of mutual exclusion locks in xv6."
    )

    add_full_step(
        doc,
        "2.2",
        "GDB Hardware Inspection of Struct Layout & 4-Byte Struct Padding Hole",
        "TERMINAL 2 (RIGHT - GDB / HOST)",
        "riscv64-elf-gdb -batch -ex \"file kernel/kernel\" -ex \"ptype /o struct shared_resource\"",
        "EXPECTED GDB OUTPUT",
        "The target architecture is set to \"riscv:rv64\".\n"
        ".gdbinit:4: Error in sourced command file:\n"
        "could not connect: Operation timed out.\n"
        "/* offset      |    size */  type = struct shared_resource {\n"
        "/*      0      |      24 */    struct spinlock {\n"
        "/*      0      |       4 */        uint locked;\n"
        "/* XXX  4-byte hole      */\n"
        "/*      8      |       8 */        char *name;\n"
        "/*     16      |       8 */        struct cpu *cpu;\n\n"
        "                                   /* total size (bytes):   24 */\n"
        "                               } lock;\n"
        "/*     24      |       4 */    volatile int counter;\n"
        "/*     28      |       4 */    volatile int total_ops;\n\n"
        "                               /* total size (bytes):   32 */\n"
        "                             }",
        "PARTICIPANT 2",
        "GDB's ptype /o confirms the physical memory layout: uint locked is at offset 0 (4 bytes). Notice the 4-byte struct padding hole! Because 64-bit pointers like char *name must align to 8-byte boundaries, the compiler pads 4 bytes. Total spinlock size: 24 bytes; total shared resource size: 32 bytes.",
        "GDB reads .gdbinit which attempts remote attachment to port 25501; since QEMU is running interactively in Terminal 1, GDB safely times out and inspects the kernel ELF binary directly. Struct alignment on 64-bit RISC-V mandates padding between 32-bit integers and 64-bit pointers."
    )

    add_full_step(
        doc,
        "2.3",
        "Code Walkthrough — acquire() in kernel/spinlock.c",
        "TERMINAL 2 (RIGHT - HOST / EDITOR)",
        "sed -n '21,42p' kernel/spinlock.c",
        "EXPECTED CODE OUTPUT",
        "void\n"
        "acquire(struct spinlock *lk)\n"
        "{\n"
        "  push_off(); // disable interrupts to avoid deadlock.\n"
        "  if (holding(lk))\n"
        "    panic(\"acquire\");\n\n"
        "  // On RISC-V, __atomic_exchange_n turns into an atomic swap:\n"
        "  //   a5 = 1\n"
        "  //   s1 = &lk->locked\n"
        "  //   amoswap.w.aq a5, a5, (s1)\n"
        "  //\n"
        "  // Passing __ATOMIC_ACQUIRE to __atomic_exchange_n tells\n"
        "  // the C compiler and the processor to not move loads or stores\n"
        "  // past this point, to ensure that the critical section's memory\n"
        "  // references happen strictly after the lock is acquired.\n"
        "  while (__atomic_exchange_n(&lk->locked, 1, __ATOMIC_ACQUIRE) != 0)\n"
        "    ;\n\n"
        "  // Record info about lock acquisition for holding() and debugging.\n"
        "  lk->cpu = mycpu();\n"
        "}",
        "PARTICIPANT 2",
        "Notice the spin loop: while(__atomic_exchange_n(&lk->locked, 1, __ATOMIC_ACQUIRE) != 0);. Upon acquiring the lock bit, it records lk->cpu = mycpu() for debugging. Let us disassemble this in GDB to see the raw hardware instruction.",
        "__atomic_exchange_n with __ATOMIC_ACQUIRE maps directly to RISC-V standard A-extension instructions."
    )

    add_full_step(
        doc,
        "2.4",
        "GDB Disassembly of acquire() & Live Machine Instructions",
        "TERMINAL 2 (RIGHT - GDB / HOST)",
        "riscv64-elf-gdb -batch -ex \"file kernel/kernel\" -ex \"disassemble acquire\"",
        "EXPECTED GDB DISASSEMBLY",
        "The target architecture is set to \"riscv:rv64\".\n"
        ".gdbinit:4: Error in sourced command file:\n"
        "could not connect: Operation timed out.\n"
        "Dump of assembler code for function acquire:\n"
        "   0x0000000080000c18 <+0>:	addi	sp,sp,-32\n"
        "   0x0000000080000c1a <+2>:	sd	ra,24(sp)\n"
        "   0x0000000080000c1c <+4>:	sd	s0,16(sp)\n"
        "   0x0000000080000c1e <+6>:	sd	s1,8(sp)\n"
        "   0x0000000080000c20 <+8>:	addi	s0,sp,32\n"
        "   0x0000000080000c22 <+10>:	mv	s1,a0\n"
        "   0x0000000080000c24 <+12>:	jal	0x80000bde <push_off>\n"
        "   0x0000000080000c28 <+16>:	mv	a0,s1\n"
        "   0x0000000080000c2a <+18>:	jal	0x80000bb2 <holding>\n"
        "   0x0000000080000c2e <+22>:	li	a4,1\n"
        "   0x0000000080000c30 <+24>:	bnez	a0,0x80000c48 <acquire+48>\n"
        "   0x0000000080000c32 <+26>:	amoswap.w.aq	a5,a4,(s1)    <-- ATOMIC SWAP WORD WITH ACQUIRE\n"
        "   0x0000000080000c36 <+30>:	bnez	a5,0x80000c32 <acquire+26> <-- SPIN LOOP IF LOCKED\n"
        "   0x0000000080000c38 <+32>:	jal	0x800018be <mycpu>\n"
        "   0x0000000080000c3c <+36>:	sd	a0,16(s1)             <-- RECORD HOLDING CPU\n"
        "   0x0000000080000c3e <+38>:	ld	ra,24(sp)\n"
        "   0x0000000080000c40 <+40>:	ld	s0,16(sp)\n"
        "   0x0000000080000c42 <+42>:	ld	s1,8(sp)\n"
        "   0x0000000080000c44 <+44>:	addi	sp,sp,32\n"
        "   0x0000000080000c46 <+46>:	ret\n"
        "   0x0000000080000c48 <+48>:	auipc	a0,0x6\n"
        "   0x0000000080000c4c <+52>:	addi	a0,a0,1024 # 0x80007048\n"
        "   0x0000000080000c50 <+56>:	jal	0x8000083a <panic>\n"
        "End of assembler dump.",
        "PARTICIPANT 2",
        "Look at offset +26 in GDB: amoswap.w.aq a5, a4, (s1)! It writes 1 from a4 into lk->locked at (s1), and loads the old value into a5 in a single indivisible bus transaction. If a5 was 0, the lock was free, so bnez a5 at +30 fails and the CPU enters the critical section. If a5 was 1, bnez a5 jumps back to +26—the CPU spins! The .aq suffix enforces Acquire Semantics: no memory access inside the critical section can be reordered before this instruction.",
        "RISC-V .aq acts as a one-way memory barrier preventing memory operations inside the critical section from hoisting outside."
    )

    add_full_step(
        doc,
        "2.5",
        "Code Walkthrough — release() in kernel/spinlock.c",
        "TERMINAL 2 (RIGHT - HOST / EDITOR)",
        "sed -n '45,75p' kernel/spinlock.c",
        "EXPECTED CODE OUTPUT",
        "void\n"
        "release(struct spinlock *lk)\n"
        "{\n"
        "  if (!holding(lk))\n"
        "    panic(\"release\");\n\n"
        "  lk->cpu = 0;\n\n"
        "  // Release the lock, equivalent to lk->locked = 0.\n"
        "  //\n"
        "  // This code doesn't use a C assignment, since the C standard\n"
        "  // implies that an assignment might be implemented with\n"
        "  // multiple store instructions.\n"
        "  //\n"
        "  // On RISC-V, __atomic_store_n turns into a single atomic store:\n"
        "  //   s1 = &lk->locked\n"
        "  //   sw zero,0(s1)\n"
        "  //\n"
        "  // The __ATOMIC_RELEASE argument to __atomic_store_n tells the\n"
        "  // the C compiler and the CPU to not move loads or stores past\n"
        "  // this point, to ensure that all the stores in the critical\n"
        "  // section are visible to other CPUs before the lock is released,\n"
        "  // and that loads in the critical section occur strictly before\n"
        "  // the lock is released.\n"
        "  //\n"
        "  // On RISC-V, this generates a fence instruction before the store:\n"
        "  //   fence rw,w\n"
        "  __atomic_store_n(&lk->locked, 0, __ATOMIC_RELEASE);\n\n"
        "  pop_off();\n"
        "}",
        "PARTICIPANT 2",
        "When the critical section finishes, release() executes: It clears lk->cpu = 0; emits fence rw,w to ensure all prior writes are globally committed; clears lk->locked = 0 using __atomic_store_n with release semantics; and calls pop_off() to restore the CPU's interrupt state.",
        "__atomic_store_n with __ATOMIC_RELEASE generates fence rw,w followed by sw zero, 0(s1)."
    )

    add_full_step(
        doc,
        "2.6",
        "GDB Disassembly of release() & Hardware Memory Barrier",
        "TERMINAL 2 (RIGHT - GDB / HOST)",
        "riscv64-elf-gdb -batch -ex \"file kernel/kernel\" -ex \"disassemble release\"",
        "EXPECTED GDB DISASSEMBLY",
        "The target architecture is set to \"riscv:rv64\".\n"
        ".gdbinit:4: Error in sourced command file:\n"
        "could not connect: Operation timed out.\n"
        "Dump of assembler code for function release:\n"
        "   0x0000000080000c9c <+0>:	addi	sp,sp,-32\n"
        "   0x0000000080000c9e <+2>:	sd	ra,24(sp)\n"
        "   0x0000000080000ca0 <+4>:	sd	s0,16(sp)\n"
        "   0x0000000080000ca2 <+6>:	sd	s1,8(sp)\n"
        "   0x0000000080000ca4 <+8>:	addi	s0,sp,32\n"
        "   0x0000000080000ca6 <+10>:	mv	s1,a0\n"
        "   0x0000000080000ca8 <+12>:	jal	0x80000bb2 <holding>\n"
        "   0x0000000080000cac <+16>:	beqz	a0,0x80000cc8 <release+44>\n"
        "   0x0000000080000cae <+18>:	sd	zero,16(s1)           <-- CLEAR lk->cpu\n"
        "   0x0000000080000cb2 <+22>:	fence	rw,w                  <-- HARDWARE MEMORY BARRIER\n"
        "   0x0000000080000cb6 <+26>:	sw	zero,0(s1)            <-- CLEAR lk->locked = 0\n"
        "   0x0000000080000cba <+30>:	jal	0x80000c54 <pop_off>  <-- RESTORE INTERRUPT STATE\n"
        "   0x0000000080000cbe <+34>:	ld	ra,24(sp)\n"
        "   0x0000000080000cc0 <+36>:	ld	s0,16(sp)\n"
        "   0x0000000080000cc2 <+38>:	ld	s1,8(sp)\n"
        "   0x0000000080000cc4 <+40>:	addi	sp,sp,32\n"
        "   0x0000000080000cc6 <+42>:	ret\n"
        "   0x0000000080000cc8 <+44>:	auipc	a0,0x6\n"
        "   0x0000000080000ccc <+48>:	addi	a0,a0,936 # 0x80007070\n"
        "   0x0000000080000cd0 <+52>:	jal	0x8000083a <panic>\n"
        "End of assembler dump.",
        "PARTICIPANT 2",
        "Look at line +22 in GDB: fence rw,w! This memory barrier guarantees that all writes from the critical section are globally committed to memory before sw zero, 0(s1) clears the lock bit. To explain how interrupts are managed safely, I hand over to Devarsh Patel.",
        "Vidit hands over to Devarsh for interrupt safety and synchronized benchmark verification."
    )

    doc.add_page_break()

    # ----------------------------------------------------
    # SECTION 3: PARTICIPANT 3 — DEVARSH PATEL
    # ----------------------------------------------------
    add_heading_1(doc, "SECTION 3: PARTICIPANT 3 — DEVARSH PATEL (24BCT0267)")
    add_heading_2(doc, "Topic: Nested Interrupt Invariants (push_off/pop_off), Complete Race Elimination, Benchmark Verification & Grand Finale")
    add_body_paragraph(doc, "Responsible Functions & Commands: push_off(), pop_off(), mycpu()->noff, racetest locked, racetest, racetest 2 500 1")

    add_say_box(
        doc,
        "PARTICIPANT 3 - OPENING DIALOGUE",
        "Thank you, Vidit. Respected professors and examiners, I am Devarsh Patel, registration number 24BCT0267. Why must spinlocks disable interrupts? If CPU 0 holds a spinlock and a timer interrupt fires on CPU 0, the CPU suspends the thread and enters trap.c. If the interrupt handler tries to acquire the same lock, CPU 0 deadlocks on itself—it cannot resume the thread to release the lock, and the handler cannot proceed. The system hangs permanently! Therefore, xv6 enforces an absolute invariant: Every spinlock acquisition disables interrupts on that CPU! Let us inspect how xv6 manages nested locks without prematurely re-enabling interrupts."
    )

    add_full_step(
        doc,
        "3.1",
        "Code Walkthrough — Per-CPU Interrupt State in kernel/proc.h",
        "TERMINAL 2 (RIGHT - HOST / EDITOR)",
        "sed -n '21,27p' kernel/proc.h",
        "EXPECTED CODE OUTPUT",
        "// Per-CPU state.\n"
        "struct cpu {\n"
        "  struct proc *proc;      // The process running on this cpu, or null.\n"
        "  struct context context; // swtch() here to enter scheduler().\n"
        "  int noff;               // Depth of push_off() nesting.\n"
        "  int intena;             // Were interrupts enabled before push_off()?\n"
        "};",
        "PARTICIPANT 3",
        "In kernel/proc.h, each core has its own struct cpu tracking noff (nesting depth) and intena (original interrupt state). If Function A acquires Lock 1, and calls Function B which acquires and releases Lock 2, releasing Lock 2 must NOT turn interrupts back on while Lock 1 is still held!",
        "Per-CPU state prevents cross-core interference during interrupt management."
    )

    add_full_step(
        doc,
        "3.2",
        "Code Walkthrough — push_off() and pop_off() in kernel/spinlock.c",
        "TERMINAL 2 (RIGHT - HOST / EDITOR)",
        "sed -n '91,115p' kernel/spinlock.c",
        "EXPECTED CODE OUTPUT",
        "void\n"
        "push_off(void)\n"
        "{\n"
        "  // disable interrupts to prevent an involuntary context\n"
        "  // switch while using mycpu().\n"
        "  uint64 flags = rc_sstatus(SSTATUS_SIE);\n"
        "  int old = !!(flags & SSTATUS_SIE);\n\n"
        "  if (mycpu()->noff == 0)\n"
        "    mycpu()->intena = old;\n"
        "  mycpu()->noff += 1;\n"
        "}\n\n"
        "void\n"
        "pop_off(void)\n"
        "{\n"
        "  struct cpu *c = mycpu();\n"
        "  if (intr_get())\n"
        "    panic(\"pop_off - interruptible\");\n"
        "  if (c->noff < 1)\n"
        "    panic(\"pop_off\");\n"
        "  c->noff -= 1;\n"
        "  if (c->noff == 0 && c->intena)\n"
        "    intr_on();\n"
        "}",
        "PARTICIPANT 3",
        "push_off() saves the original interrupt state in intena only on the very first lock (noff == 0), and increments noff. pop_off() decrements noff, and only re-enables interrupts (intr_on()) when noff returns to zero!",
        "rc_sstatus reads SSTATUS_SIE, and intr_off() clears the SIE bit in sstatus using csrrci."
    )

    add_full_step(
        doc,
        "3.3",
        "Code Walkthrough — Synchronized Critical Section in kernel/race.c",
        "TERMINAL 2 (RIGHT - HOST / EDITOR)",
        "sed -n '59,71p' kernel/race.c",
        "EXPECTED CODE OUTPUT",
        "  for (int i = 0; i < iterations; i++) {\n"
        "    if (use_lock) {\n"
        "      // Synchronized critical section using xv6 spinlock\n"
        "      acquire(&shared_res.lock);\n\n"
        "      volatile int temp = shared_res.counter;\n"
        "      for (volatile int d = 0; d < 30; d++)\n"
        "        ;\n"
        "      shared_res.counter = temp + 1;\n"
        "      shared_res.total_ops++;\n\n"
        "      release(&shared_res.lock);\n"
        "    } else {",
        "PARTICIPANT 3",
        "When use_lock == 1, the entire read-modify-write sequence is wrapped between acquire(&shared_res.lock) and release(&shared_res.lock). Let us execute this live and observe the results!",
        "Serializes concurrent thread access so that every read-modify-write operates on the most recently committed state."
    )

    add_full_step(
        doc,
        "3.4",
        "Execute Live Synchronized Benchmark (racetest locked)",
        "TERMINAL 1 (LEFT - QEMU SHELL)",
        "racetest locked",
        "EXPECTED SCREEN OUTPUT",
        "$ racetest locked\n\n"
        "############################################################\n"
        "#  xv6 MULTIPROCESSOR RACE CONDITION & SPINLOCK SUITE      #\n"
        "#  Team: WindowsXP | Tejas, Vidit, Devarsh                 #\n"
        "############################################################\n\n"
        "============================================================\n"
        "[SYNCHRONIZED TEST] Mode: xv6 Spinlock (acquire / release)\n"
        "Protection: Mutual Exclusion ENABLED\n"
        "Configuration: 4 child processes x 1000 iterations\n"
        "Expected Counter Result: 4000\n"
        "------------------------------------------------------------\n"
        "Spawning 4 concurrent processes across CPUs...\n"
        "Execution Complete. Reading final shared kernel counter...\n"
        "------------------------------------------------------------\n"
        "  >> Expected Value  : 4000\n"
        "  >> Actual Counter  : 4000\n"
        "  >> Lost Updates    : 0 (0% data loss)\n"
        "------------------------------------------------------------\n"
        "VERDICT: PERFECT MUTUAL EXCLUSION!\n"
        "xv6 Spinlock eliminated race condition. 100% updates preserved.\n"
        "============================================================",
        "PARTICIPANT 3",
        "Look at the terminal output! Expected: 4,000; Actual: 4,000; Lost Updates: 0 (0% data loss!). The xv6 spinlock has completely eliminated the race condition!",
        "All 4,000 critical sections were strictly serialized across both CPU cores."
    )

    add_full_step(
        doc,
        "3.5",
        "Execute Automated Full Comparative Benchmark (racetest)",
        "TERMINAL 1 (LEFT - QEMU SHELL)",
        "racetest",
        "EXPECTED SCREEN OUTPUT",
        "$ racetest\n\n"
        "############################################################\n"
        "#  xv6 MULTIPROCESSOR RACE CONDITION & SPINLOCK SUITE      #\n"
        "#  Team: WindowsXP | Tejas, Vidit, Devarsh                 #\n"
        "############################################################\n\n"
        "Running automated comprehensive benchmark (4 processes x 1000 ops)...\n\n"
        "============================================================\n"
        "[RACE CONDITION TEST] Mode: Unlocked (Concurrent Read-Modify-Write)\n"
        "Protection: NONE (Vulnerable to SMP Race Window)\n"
        "Configuration: 4 child processes x 1000 iterations\n"
        "Expected Counter Result: 4000\n"
        "------------------------------------------------------------\n"
        "Spawning 4 concurrent processes across CPUs...\n"
        "Execution Complete. Reading final shared kernel counter...\n"
        "------------------------------------------------------------\n"
        "  >> Expected Value  : 4000\n"
        "  >> Actual Counter  : 1000\n"
        "  >> Lost Updates    : 3000 (75% data loss)\n"
        "------------------------------------------------------------\n"
        "VERDICT: RACE CONDITION CONFIRMED!\n"
        "Interleaved memory access on multi-core CPU caused 3000 lost updates.\n"
        "============================================================\n\n"
        "============================================================\n"
        "[SYNCHRONIZED TEST] Mode: xv6 Spinlock (acquire / release)\n"
        "Protection: Mutual Exclusion ENABLED\n"
        "Configuration: 4 child processes x 1000 iterations\n"
        "Expected Counter Result: 4000\n"
        "------------------------------------------------------------\n"
        "Spawning 4 concurrent processes across CPUs...\n"
        "Execution Complete. Reading final shared kernel counter...\n"
        "------------------------------------------------------------\n"
        "  >> Expected Value  : 4000\n"
        "  >> Actual Counter  : 4000\n"
        "  >> Lost Updates    : 0 (0% data loss)\n"
        "------------------------------------------------------------\n"
        "VERDICT: PERFECT MUTUAL EXCLUSION!\n"
        "xv6 Spinlock eliminated race condition. 100% updates preserved.\n"
        "============================================================",
        "PARTICIPANT 3",
        "When run head-to-head in our automated comparison: Without locking: 3,000 lost updates and 75% data corruption. With xv6 spinlocks: Zero lost updates and 100.0% data integrity! This side-by-side contrast provides conclusive empirical proof of spinlock mutual exclusion.",
        "Demonstrates the absolute contrast between unprotected concurrent access and synchronized access under identical CPU workloads."
    )

    add_full_step(
        doc,
        "3.6",
        "Execute Parametric Synchronized Test with 2 Processes",
        "TERMINAL 1 (LEFT - QEMU SHELL)",
        "racetest 2 500 1",
        "EXPECTED SCREEN OUTPUT",
        "$ racetest 2 500 1\n\n"
        "############################################################\n"
        "#  xv6 MULTIPROCESSOR RACE CONDITION & SPINLOCK SUITE      #\n"
        "#  Team: WindowsXP | Tejas, Vidit, Devarsh                 #\n"
        "############################################################\n\n"
        "============================================================\n"
        "[SYNCHRONIZED TEST] Mode: xv6 Spinlock (acquire / release)\n"
        "Protection: Mutual Exclusion ENABLED\n"
        "Configuration: 2 child processes x 500 iterations\n"
        "Expected Counter Result: 1000\n"
        "------------------------------------------------------------\n"
        "Spawning 2 concurrent processes across CPUs...\n"
        "Execution Complete. Reading final shared kernel counter...\n"
        "------------------------------------------------------------\n"
        "  >> Expected Value  : 1000\n"
        "  >> Actual Counter  : 1000\n"
        "  >> Lost Updates    : 0 (0% data loss)\n"
        "------------------------------------------------------------\n"
        "VERDICT: PERFECT MUTUAL EXCLUSION!\n"
        "xv6 Spinlock eliminated race condition. 100% updates preserved.\n"
        "============================================================",
        "PARTICIPANT 3",
        "In the 2-process trial, where unlocked mode suffered 500 lost updates, spinlock protection preserves all 1,000 increments perfectly.",
        "Validates mutual exclusion across multiple process topologies."
    )

    add_full_step(
        doc,
        "3.7",
        "Grand Finale & Architectural Conclusion",
        "TERMINAL 1 (LEFT) & TERMINAL 2 (RIGHT)",
        "echo '=== PRESENTATION SUMMARY COMPLETE ==='",
        "EXPECTED SCREEN OUTPUT",
        "$ echo '=== PRESENTATION SUMMARY COMPLETE ==='\n"
        "'=== PRESENTATION SUMMARY COMPLETE ==='\n"
        "$ ",
        "PARTICIPANT 3",
        "To conclude, we have demonstrated the three fundamental pillars of operating system concurrency: 1. Concurrency Hazards: Unprotected read-modify-write sequences (lw, addiw, sw) allow race windows where concurrent CPU cores overwrite each other's memory updates. 2. Hardware Atomics: Software locks require atomic hardware primitives (amoswap.w.aq on RISC-V) and memory barriers (fence rw,w) to guarantee atomicity and prevent memory reordering. 3. Interrupt Safety Invariant: Spinlocks must disable interrupts on the holding core using nested depth tracking (push_off/pop_off) to prevent unrecoverable single-core recursive deadlocks. Tejas, Vidit, and I are now ready to take any questions from the evaluators. Thank you!",
        "Final synthesis of all demonstrated concurrency principles."
    )

    doc.add_page_break()

    # ----------------------------------------------------
    # SECTION 4: COMPARATIVE EXPERIMENTAL RESULTS MATRIX
    # ----------------------------------------------------
    add_heading_1(doc, "SECTION 4: COMPARATIVE EXPERIMENTAL RESULTS MATRIX")
    add_body_paragraph(doc, "The following matrix consolidates all empirical test runs conducted on the live xv6 kernel under SMP configuration (CPUS=2):")

    tbl_res = doc.add_table(rows=12, cols=3)
    tbl_res.alignment = WD_TABLE_ALIGNMENT.CENTER
    tbl_res.autofit = False

    res_headers = ["Metric / Architectural Parameter", "Unlocked Benchmark (Test 1)", "Spinlock-Protected (Test 2)"]
    res_widths = [Inches(2.5), Inches(2.2), Inches(2.3)]
    
    for c_idx, h_text in enumerate(res_headers):
        cell = tbl_res.cell(0, c_idx)
        cell.width = res_widths[c_idx]
        set_cell_background(cell, HEX_DARK_BLUE)
        set_cell_margins(cell, top=70, bottom=70, left=80, right=80)
        p = cell.paragraphs[0]; p.paragraph_format.space_before = Pt(1); p.paragraph_format.space_after = Pt(1)
        r = p.add_run(h_text); r.font.name = "Arial"; r.font.size = Pt(8.5); r.font.bold = True; r.font.color.rgb = RGBColor(255, 255, 255)

    matrix_data = [
        ("Concurrency Control Mode", "Unprotected Read-Modify-Write", "xv6 Spinlock (acquire / release)"),
        ("Symmetric Multiprocessing (SMP)", "CPUS=2 (2 Active RISC-V Harts)", "CPUS=2 (2 Active RISC-V Harts)"),
        ("Concurrent Processes Spawned", "4 Child Processes (forked)", "4 Child Processes (forked)"),
        ("Increments per Process", "1,000 Iterations", "1,000 Iterations"),
        ("Expected Total Counter", "4,000", "4,000"),
        ("Actual Recorded Counter", "1,000", "4,000"),
        ("Lost Updates (Collisions)", "3,000 Lost Increments", "0 (Zero Lost Increments)"),
        ("Data Corruption Rate", "75.0% Data Loss", "0.0% (100% Data Integrity)"),
        ("Hardware Atomic Instruction", "None (Uncoordinated lw/sw)", "amoswap.w.aq a5, a4, (s1)"),
        ("Hardware Memory Barrier", "None", "fence rw,w"),
        ("Interrupt Safety Mechanism", "None (Vulnerable to Preemption)", "push_off() / pop_off() Nesting"),
    ]

    for r_idx, (p_name, u_val, l_val) in enumerate(matrix_data):
        c0 = tbl_res.cell(r_idx + 1, 0)
        c1 = tbl_res.cell(r_idx + 1, 1)
        c2 = tbl_res.cell(r_idx + 1, 2)
        
        c0.width = res_widths[0]; c1.width = res_widths[1]; c2.width = res_widths[2]
        
        bg = "F8FAFC" if r_idx % 2 == 0 else "FFFFFF"
        set_cell_background(c0, bg)
        set_cell_background(c1, "FEF2F2" if "Loss" in u_val or "Lost" in u_val or "None" in u_val else bg)
        set_cell_background(c2, "F0FDF4" if "100%" in l_val or "Zero" in l_val or "Spinlock" in l_val else bg)
        
        for c in (c0, c1, c2):
            set_cell_margins(c, top=60, bottom=60, left=80, right=80)
            set_cell_border(c, bottom=dict(val="single", sz="4", color=HEX_BORDER))
            
        p0 = c0.paragraphs[0]; p0.paragraph_format.space_before = Pt(1); p0.paragraph_format.space_after = Pt(1)
        r0 = p0.add_run(p_name); r0.font.name = "Arial"; r0.font.size = Pt(8.5); r0.font.bold = True; r0.font.color.rgb = COLOR_NAVY
        
        p1 = c1.paragraphs[0]; p1.paragraph_format.space_before = Pt(1); p1.paragraph_format.space_after = Pt(1)
        r1 = p1.add_run(u_val); r1.font.name = "Arial"; r1.font.size = Pt(8.5); r1.font.color.rgb = COLOR_DANGER_TEXT if "Loss" in u_val or "Lost" in u_val else COLOR_TEXT_MAIN
        
        p2 = c2.paragraphs[0]; p2.paragraph_format.space_before = Pt(1); p2.paragraph_format.space_after = Pt(1)
        r2 = p2.add_run(l_val); r2.font.name = "Arial"; r2.font.size = Pt(8.5); r2.font.color.rgb = COLOR_SUCCESS_TEXT if "100%" in l_val or "Zero" in l_val else COLOR_TEXT_MAIN

    doc.add_page_break()

    # ----------------------------------------------------
    # SECTION 5: EXHAUSTIVE VIVA & DEFENSE PREPARATION
    # ----------------------------------------------------
    add_heading_1(doc, "SECTION 5: EXHAUSTIVE VIVA & DEFENSE PREPARATION (EXAMINER Q&A)")
    
    viva_qa = [
        ("Q1: What is the fundamental difference between a spinlock and a sleeplock in xv6? When should each be used?",
         "A spinlock keeps the CPU actively executing in a tight polling loop (while(amoswap...)) until the lock becomes free. It disables interrupts on the local core via push_off() and strictly prohibits yielding or sleeping (sched() explicitly checks mycpu()->noff == 1; otherwise it panics). Spinlocks are designed for very short critical sections (e.g. updating process state, manipulating free lists, buffer cache pointers) where holding time is negligible.\n\n"
         "A sleeplock (kernel/sleeplock.c) puts the calling process to sleep (sleep()), yielding the CPU to the scheduler so other processes can execute while waiting. Sleeplocks leave interrupts enabled and are used for long-duration operations involving disk I/O or pipe waits where spinning would waste millions of CPU cycles."),

        ("Q2: Why does xv6 panic if a kernel thread tries to sleep (sleep()) or yield (yield()) while holding a spinlock?",
         "If Process A holds a spinlock on CPU 0 and yields or goes to sleep:\n"
         "1. CPU 0 is switched to Process B.\n"
         "2. If Process B (or another process on CPU 1) attempts to acquire that same spinlock, it will spin continuously.\n"
         "3. If Process B is running on CPU 0, Process A cannot run to release the lock because Process B is monopolizing CPU 0 spinning.\n"
         "4. Even worse, if Process A was holding p->lock or a shared subsystem lock, deadlocks propagate across all cores.\n"
         "To prevent this, xv6's sched() asserts: if(mycpu()->noff != 1) panic(\"sched locks\"); (where noff == 1 accounts only for the scheduler's own p->lock)."),

        ("Q3: What is the purpose of the .aq suffix in amoswap.w.aq? What would go wrong without it?",
         "The .aq suffix denotes Acquire Semantics in the RISC-V memory consistency model. Modern superscalar out-of-order processors and memory controllers can reorder read and write instructions for performance. Without .aq, memory accesses belonging inside the critical section could be speculatively fetched or executed before the lock is officially acquired, allowing another core to observe or overwrite data concurrently, violating mutual exclusion!"),

        ("Q4: Why does release() require fence rw,w before clearing the lock word?",
         "fence rw,w is a hardware memory barrier instruction. It dictates that all Device and Memory Read and Write operations preceding the fence must be committed and visible to all other CPU cores before the Write operation following the fence (sw zero, 0(s1)) is executed. Without this fence, a processor might flush the lock release to memory before the modifications made inside the critical section reach the cache coherency bus. Another CPU acquiring the lock would then read stale data."),

        ("Q5: Can a spinlock be acquired recursively by the same CPU? What happens in xv6?",
         "No! xv6 spinlocks are non-recursive. If a CPU holding lock lk attempts to call acquire(lk) again, xv6 detects this via holding(lk): if(holding(lk)) panic(\"acquire\");. If this check did not exist, amoswap.w.aq would see lk->locked == 1 and spin forever waiting for the lock to be released, which will never happen because the only core capable of releasing it is stuck spinning!"),

        ("Q6: Why does push_off() record intena only when noff == 0?",
         "When locks are nested:\n"
         "- Lock 1 is acquired when interrupts might be ON (intena = 1). noff increments from 0 to 1.\n"
         "- Lock 2 is acquired. Interrupts are ALREADY off due to Lock 1! noff increments from 1 to 2.\n"
         "If push_off() recorded intena when noff == 1, it would record intena = 0 (interrupts disabled). Then, when Lock 2 was released, pop_off() would see intena = 0 and fail to restore interrupts when Lock 1 is finally released! Recording only at noff == 0 preserves the true initial interrupt state of the processor before any locks were taken."),

        ("Q7: Why are spinlocks ineffective on a single-core uniprocessor (CPUS=1) without preemption?",
         "On a single core without preemption, if a thread attempts to acquire a held spinlock, no other thread or core can run to release it. The CPU will spin indefinitely, resulting in a permanent hang. On uniprocessors, mutual exclusion is achieved simply by disabling interrupts (intr_off()). Spinlocks are specifically designed for symmetric multiprocessor (SMP) architectures where the lock holder is concurrently executing on a different physical CPU.")
    ]

    for q_text, a_text in viva_qa:
        add_heading_2(doc, q_text)
        add_body_paragraph(doc, a_text)

    doc.add_page_break()

    # ----------------------------------------------------
    # SECTION 6: COMPLETE SOURCE CODE APPENDIX
    # ----------------------------------------------------
    add_heading_1(doc, "SECTION 6: COMPLETE KERNEL & USER SOURCE CODE APPENDIX")
    
    add_heading_2(doc, "6.1 kernel/race.c (Shared Kernel Resource & Spinlock Implementation)")
    with open("kernel/race.c", "r") as f:
        race_c_code = f.read()
    add_command_box(doc, "SOURCE CODE: kernel/race.c", race_c_code)

    add_heading_2(doc, "6.2 user/racetest.c (Benchmarking & Demonstration Suite)")
    with open("user/racetest.c", "r") as f:
        racetest_c_code = f.read()
    add_command_box(doc, "SOURCE CODE: user/racetest.c", racetest_c_code)

    # Save directly to Downloads folder
    downloads_docx = "/Users/raffe/Downloads/XV6_SPINLOCK_RACE_PRESENTATION.docx"
    doc.save(downloads_docx)
    print(f"[SUCCESS] Saved Master Word Document directly to Downloads: {downloads_docx}")

    downloads_md = "/Users/raffe/Downloads/XV6_SPINLOCK_RACE_PRESENTATION.md"
    export_markdown(downloads_md)
    print(f"[SUCCESS] Saved Master Markdown Guide directly to Downloads: {downloads_md}")

def export_markdown(output_path):
    with open("kernel/race.c", "r") as f:
        race_c = f.read()
    with open("user/racetest.c", "r") as f:
        racetest_c = f.read()

    md = """# xv6 Multiprocessor Race Condition & Spinlock Synchronization Trace
## Complete Synchronized Line-by-Line Presentation Manual & Viva Defense Guide
**1 Command ➔ 1 Screen Output ➔ 1 Exact Spoken Script ➔ 1 Examiner Defense Point**

---

### 🚨 CRITICAL RECOVERY & EXECUTION RULES
1. If GDB ever displays `No symbol table is loaded`, simply type: `file kernel/kernel`
2. Always ensure QEMU runs with `CPUS=2` (or higher) to enable true symmetric multiprocessing.
3. Keep **Terminal 1 on Left** (QEMU xv6 Shell) and **Terminal 2 on Right** (Host Shell / GDB Debugger).
4. **Team WindowsXP Presenter Sequence**: Participant 1 = Tejas, Participant 2 = Vidit, Participant 3 = Devarsh.

---

### Presenter Roster & Architecture Allocation

| Presenter & Team | Core Technical Topic | Key Functions, Hardware Instructions & State |
| :--- | :--- | :--- |
| **Participant 1: Tejas Deshpande**<br>Reg: `24BKT0145`<br>Team `WindowsXP` | Concurrency Foundations, Multiprocessor Race Windows & Ground Zero Live Unlocked Race | `struct shared_resource`, `counter++`, `race_increment(iters, 0)`, `racetest`<br>Non-atomic Read-Modify-Write (`lw` -> `addiw` -> `sw`) -> **75% Lost Updates** |
| **Participant 2: Vidit Agrawal**<br>Reg: `24BKT0139`<br>Team `WindowsXP` | xv6 Spinlock Internals, RISC-V Hardware Atomics (`amoswap.w.aq`), Memory Fences & GDB | `acquire()`, `release()`, `struct spinlock` (24B with 4B padding hole)<br>`amoswap.w.aq a5, a4, (s1)` (Acquire barrier), `fence rw,w`, `sw zero` |
| **Participant 3: Devarsh Patel**<br>Reg: `24BCT0267`<br>Team `WindowsXP` | Nested Interrupt Invariants (`push_off`/`pop_off`), Complete Race Elimination & Benchmarks | `push_off()`, `pop_off()`, `mycpu()->noff`, `mycpu()->intena`, `sstatus SIE`<br>`racetest locked` -> **100% Mutual Exclusion** (4000/4000, 0 Lost Updates) |

---

## SECTION 0: PRE-PRESENTATION TERMINAL SETUP

### Step 0.1: Clean Build Kernel, Filesystem & .gdbinit Configuration
- **Terminal Setup (Run Once in Terminal 1)**:
```bash
cd /Users/raffe/Documents/GitHub/lab-da-1-system-call-tracing-in-xv6-windowsxp__
export PATH="/Library/Developer/CommandLineTools/usr/bin:$PATH"
make clean
make -j4 kernel/kernel fs.img .gdbinit
```
- **Expected Build Output**:
```text
riscv64-unknown-elf-gcc ... -c -o kernel/race.o kernel/race.c
riscv64-unknown-elf-gcc ... -c -o user/racetest.o user/racetest.c
riscv64-unknown-elf-ld -z max-page-size=4096 -T kernel/kernel.ld -o kernel/kernel ...
mkfs/mkfs fs.img README ... user/_racetest
nmeta 47 blocks 1953 total 2000
```
- **What to Say (Tejas)**:
> *"We begin by compiling a clean xv6 kernel with our shared resource subsystem and user benchmark binary racetest. Both fs.img and .gdbinit are primed for execution."*
- **Under The Hood**:
> The Makefile compiles `kernel/race.c` into `kernel/race.o`, registers `SYS_race_inc`, `SYS_race_get`, and `SYS_race_reset`, and packs `user/_racetest` into the root filesystem image.

---

## SECTION 1: PARTICIPANT 1 — TEJAS DESHPANDE (24BKT0145)
**Topic**: Concurrency Foundations, Multiprocessor Race Windows & Ground Zero Live Unlocked Race  
**Responsible Functions & Commands**: `struct shared_resource`, `race_increment(iters, 0)`, `racetest unlocked`, `racetest 2 500 0`

- **Opening Dialogue (Tejas)**:
> *"Respected Professor and peers, good morning. I am Tejas Deshpande, registration number 24BKT0145, representing team WindowsXP. Today, our team will present a live hardware and kernel demonstration of multiprocessor race conditions on shared kernel data structures in xv6 on RISC-V, and their complete elimination using xv6 spinlocks. When multiple CPUs execute concurrently without locking, instruction interleaving causes lost updates. Consider counter++: at the machine level, it requires a load word, an add immediate word, and a store word. If two cores execute this simultaneously, both read the identical stale value before either stores back. One increment overwrites the other, causing a Lost Update. Let us examine the shared kernel data structure in code."*

### Step 1.1: Inspect Shared Kernel Data Structure in kernel/race.c
- **Terminal 2 (Right - Host / Editor)**:
```bash
sed -n '13,30p' kernel/race.c
```
- **Expected Code Output**:
```c
// Shared kernel data structure subject to concurrent manipulation
struct shared_resource {
  struct spinlock lock;        // Dedicated xv6 spinlock for mutual exclusion
  volatile int counter;        // Shared integer counter
  volatile int total_ops;      // Audit tracker for completed increments
};

static struct shared_resource shared_res;

// Initialize the shared resource and its spinlock
void
race_init(void)
{
  initlock(&shared_res.lock, "race_counter");
  shared_res.counter = 0;
  shared_res.total_ops = 0;
}
```
- **What to Say (Tejas)**:
> *"In Terminal 2, we inspect kernel/race.c. We define struct shared_resource containing our dedicated spinlock, a volatile counter, and an operation tracker. The volatile keyword informs the compiler that memory may change asynchronously, preventing register caching. We declare static struct shared_resource shared_res in kernel BSS, making it a single global shared memory object accessible to all cores."*
- **Under The Hood**:
> `shared_res` is placed in the global kernel data segment. Every process executing a system call in kernel mode maps this identical physical memory address.

### Step 1.2: Inspect Vulnerable Unlocked Critical Section in kernel/race.c
- **Terminal 2 (Right - Host / Editor)**:
```bash
sed -n '71,88p' kernel/race.c
```
- **Expected Code Output**:
```c
    } else {
      // Unprotected critical section (VULNERABLE TO RACE CONDITIONS)
      // Read shared state into local register
      volatile int temp = shared_res.counter;

      // In unlocked mode, preemption/context-switching or core interleaving
      // during the vulnerable read-modify-write window causes lost updates.
      if ((i % 5) == 0) {
        yield();
      } else {
        for (volatile int d = 0; d < 30; d++)
          ;
      }

      // Overwrite shared state with stale computation -> Lost Update occurs
      shared_res.counter = temp + 1;
      shared_res.total_ops++;
    }
```
*(Note: running `sed -n '72,86p' kernel/race.c` isolates lines 72 to 86 ending directly at `shared_res.counter = temp + 1;`.)*
- **What to Say (Tejas)**:
> *"Notice lines 71 to 88: when use_lock == 0, the critical section is completely unprotected. Process 1 reads temp = shared_res.counter. During the race window, preemption or delays allow Process 2 on CPU 1 to read the same stale value and commit its increments. When Process 1 resumes, it writes its own temp + 1, completely overwriting and wiping out Process 2's updates!"*
- **Under The Hood**:
> Non-atomic read-modify-write permits concurrent interleaving across hardware harts, violating the atomicity guarantee.

### Step 1.3: Inspect User Benchmark Utility in user/racetest.c
- **Terminal 2 (Right - Host / Editor)**:
```bash
sed -n '26,47p' user/racetest.c
```
- **Expected Code Output**:
```c
  race_reset();

  printf("Spawning %d concurrent processes across CPUs...\\n", num_children);
  for (int i = 0; i < num_children; i++) {
    int pid = fork();
    if (pid < 0) {
      printf("racetest: fork failed on child %d\\n", i);
      exit(1);
    }
    if (pid == 0) {
      // Child process: execute kernel increments concurrently
      race_inc(iters, use_lock);
      exit(0);
    }
  }

  // Parent process: await completion of all concurrent children
  for (int i = 0; i < num_children; i++) {
    wait(0);
  }
```
- **What to Say (Tejas)**:
> *"In user space, racetest.c calls race_reset() to zero the kernel counter, forks multiple child processes that execute race_inc() concurrently, and calls wait(0) before reading the final value with race_get()."*
- **Under The Hood**:
> When multiple child processes are RUNNABLE, the xv6 scheduler distributes them across available CPU cores (`CPUS=2`), creating simultaneous parallel execution.

### Step 1.4: Launch xv6 with Symmetric Multiprocessing (CPUS=2)
- **Terminal 1 (Left - QEMU Shell)**:
```bash
make CPUS=2 qemu
```
- **Expected Screen Output**:
```text
qemu-system-riscv64 -machine virt -bios none -kernel kernel/kernel -m 128M -smp 2 -nographic -global virtio-mmio.force-legacy=false -drive file=fs.img,if=none,format=raw,id=x0 -device virtio-blk-device,drive=x0,bus=virtio-mmio-bus.0

xv6 kernel is booting

hart 1 starting
init: starting sh
$ 
```
- **What to Say (Tejas)**:
> *"In Terminal 1 on the left, we boot xv6 in QEMU configured with CPUS=2. Notice the line: hart 1 starting. Hart 0 boots the kernel and wakes up Hart 1. Both cores are now running their scheduler loops in parallel."*
- **Under The Hood**:
> CPU 0 initializes kernel memory, then sets `started = 1` with a memory fence (`__atomic_thread_fence`), allowing CPU 1 to break out of its spinloop in `main.c` and enter `scheduler()`.

### Step 1.5: Execute Ground Zero Live Unlocked Race Demonstration
- **Terminal 1 (Left - QEMU Shell)**:
```bash
racetest unlocked
```
- **Expected Screen Output**:
```text
$ racetest unlocked

############################################################
#  xv6 MULTIPROCESSOR RACE CONDITION & SPINLOCK SUITE      #
#  Team: WindowsXP | Tejas, Vidit, Devarsh                 #
############################################################

============================================================
[RACE CONDITION TEST] Mode: Unlocked (Concurrent Read-Modify-Write)
Protection: NONE (Vulnerable to SMP Race Window)
Configuration: 4 child processes x 1000 iterations
Expected Counter Result: 4000
------------------------------------------------------------
Spawning 4 concurrent processes across CPUs...
Execution Complete. Reading final shared kernel counter...
------------------------------------------------------------
  >> Expected Value  : 4000
  >> Actual Counter  : 1000
  >> Lost Updates    : 3000 (75% data loss)
------------------------------------------------------------
VERDICT: RACE CONDITION CONFIRMED!
Interleaved memory access on multi-core CPU caused 3000 lost updates.
============================================================
```
- **What to Say (Tejas)**:
> *"Look at the terminal output on the screen! 4 concurrent child processes executed 1,000 kernel increments each. We mathematically expected 4,000. Instead, the actual recorded value is only 1,000! A staggering 3,000 updates were lost—representing 75% data loss due to uncoordinated concurrent memory overwrites! This provides undeniable live proof of a race condition on a shared kernel data structure."*
- **Under The Hood**:
> As the 4 processes interleave across cores, processes continuously read stale snapshots of `shared_res.counter`, resulting in 3 out of every 4 increments being wiped out.

### Step 1.6: Execute Parametric 2-Process Collision Test
- **Terminal 1 (Left - QEMU Shell)**:
```bash
racetest 2 500 0
```
- **Expected Screen Output**:
```text
$ racetest 2 500 0

############################################################
#  xv6 MULTIPROCESSOR RACE CONDITION & SPINLOCK SUITE      #
#  Team: WindowsXP | Tejas, Vidit, Devarsh                 #
############################################################

============================================================
[RACE CONDITION TEST] Mode: Unlocked (Concurrent Read-Modify-Write)
Protection: NONE (Vulnerable to SMP Race Window)
Configuration: 2 child processes x 500 iterations
Expected Counter Result: 1000
------------------------------------------------------------
Spawning 2 concurrent processes across CPUs...
Execution Complete. Reading final shared kernel counter...
------------------------------------------------------------
  >> Expected Value  : 1000
  >> Actual Counter  : 500
  >> Lost Updates    : 500 (50% data loss)
------------------------------------------------------------
VERDICT: RACE CONDITION CONFIRMED!
Interleaved memory access on multi-core CPU caused 500 lost updates.
============================================================
```
- **What to Say (Tejas)**:
> *"With 2 processes x 500 operations, expected: 1,000; actual: 500—exactly 50% data loss! If this counter had represented a process table entry count or a free memory page list, this silent corruption would crash the operating system. How does an OS eliminate this? Through Mutual Exclusion. I now hand over to Vidit Agrawal for spinlock internals and hardware atomics."*

---

## SECTION 2: PARTICIPANT 2 — VIDIT AGRAWAL (24BKT0139)
**Topic**: xv6 Spinlock Internals, RISC-V Hardware Atomics (`amoswap.w.aq`), Memory Fences & GDB Hardware Step-Through  
**Responsible Functions & Commands**: `struct spinlock`, `acquire()`, `release()`, `amoswap.w.aq`, `fence rw,w`, GDB disassembly

- **Opening Dialogue (Vidit)**:
> *"Thank you, Tejas. Respected evaluators, I am Vidit Agrawal, registration number 24BKT0139. Software-level flags like if (!locked) locked = 1; fail because that check-and-set sequence can itself be interrupted midway. We need an indivisible hardware guarantee: atomicity. In xv6, the primary mutual exclusion primitive is the spinlock. Let us inspect how xv6 implements spinlocks down to the raw RISC-V assembly and CPU cache coherency."*

### Step 2.1: Code Walkthrough — struct spinlock Definition
- **Terminal 2 (Right - Host / Editor)**:
```bash
sed -n '1,12p' kernel/spinlock.h
```
- **Expected Code Output**:
```c
// Mutual exclusion lock.
struct spinlock {
  uint locked; // Is the lock held?

  // For debugging:
  char *name;      // Name of lock.
  struct cpu *cpu; // The cpu holding the lock.
};
```
- **What to Say (Vidit)**:
> *"In kernel/spinlock.h, struct spinlock contains uint locked (0 = free, 1 = held), name for diagnostics, and struct cpu *cpu to track ownership and detect illegal recursive acquisitions."*

### Step 2.2: GDB Hardware Inspection of Struct Layout & 4-Byte Struct Padding Hole
- **Terminal 2 (Right - GDB / Host)**:
```bash
riscv64-elf-gdb -batch -ex "file kernel/kernel" -ex "ptype /o struct shared_resource"
```
- **Expected GDB Output**:
```text
The target architecture is set to "riscv:rv64".
.gdbinit:4: Error in sourced command file:
could not connect: Operation timed out.
/* offset      |    size */  type = struct shared_resource {
/*      0      |      24 */    struct spinlock {
/*      0      |       4 */        uint locked;
/* XXX  4-byte hole      */
/*      8      |       8 */        char *name;
/*     16      |       8 */        struct cpu *cpu;

                                   /* total size (bytes):   24 */
                               } lock;
/*     24      |       4 */    volatile int counter;
/*     28      |       4 */    volatile int total_ops;

                               /* total size (bytes):   32 */
                             }
```
- **What to Say (Vidit)**:
> *"GDB's ptype /o confirms the physical memory layout: uint locked is at offset 0 (4 bytes). Notice the 4-byte struct padding hole! Because 64-bit pointers like char *name must align to 8-byte boundaries, the compiler pads 4 bytes. Total spinlock size: 24 bytes; total shared resource size: 32 bytes."*
- **Under The Hood**:
> GDB reads `.gdbinit` which attempts remote attachment to port 25501; since QEMU is running interactively in Terminal 1, GDB safely times out and inspects the kernel ELF binary directly. Struct alignment on 64-bit RISC-V mandates padding between 32-bit integers and 64-bit pointers.

### Step 2.3: Code Walkthrough — acquire() in kernel/spinlock.c
- **Terminal 2 (Right - Host / Editor)**:
```bash
sed -n '21,42p' kernel/spinlock.c
```
- **Expected Code Output**:
```c
void
acquire(struct spinlock *lk)
{
  push_off(); // disable interrupts to avoid deadlock.
  if (holding(lk))
    panic("acquire");

  // On RISC-V, __atomic_exchange_n turns into an atomic swap:
  //   a5 = 1
  //   s1 = &lk->locked
  //   amoswap.w.aq a5, a5, (s1)
  //
  // Passing __ATOMIC_ACQUIRE to __atomic_exchange_n tells
  // the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen strictly after the lock is acquired.
  while (__atomic_exchange_n(&lk->locked, 1, __ATOMIC_ACQUIRE) != 0)
    ;

  // Record info about lock acquisition for holding() and debugging.
  lk->cpu = mycpu();
}
```
- **What to Say (Vidit)**:
> *"Notice the spin loop: while(__atomic_exchange_n(&lk->locked, 1, __ATOMIC_ACQUIRE) != 0);. Upon acquiring the lock bit, it records lk->cpu = mycpu() for debugging. Let us disassemble this in GDB to see the raw hardware instruction."*

### Step 2.4: GDB Disassembly of acquire() & Live Machine Instructions
- **Terminal 2 (Right - GDB / Host)**:
```bash
riscv64-elf-gdb -batch -ex "file kernel/kernel" -ex "disassemble acquire"
```
- **Expected GDB Disassembly**:
```text
The target architecture is set to "riscv:rv64".
.gdbinit:4: Error in sourced command file:
could not connect: Operation timed out.
Dump of assembler code for function acquire:
   0x0000000080000c18 <+0>:	addi	sp,sp,-32
   0x0000000080000c1a <+2>:	sd	ra,24(sp)
   0x0000000080000c1c <+4>:	sd	s0,16(sp)
   0x0000000080000c1e <+6>:	sd	s1,8(sp)
   0x0000000080000c20 <+8>:	addi	s0,sp,32
   0x0000000080000c22 <+10>:	mv	s1,a0
   0x0000000080000c24 <+12>:	jal	0x80000bde <push_off>
   0x0000000080000c28 <+16>:	mv	a0,s1
   0x0000000080000c2a <+18>:	jal	0x80000bb2 <holding>
   0x0000000080000c2e <+22>:	li	a4,1
   0x0000000080000c30 <+24>:	bnez	a0,0x80000c48 <acquire+48>
   0x0000000080000c32 <+26>:	amoswap.w.aq	a5,a4,(s1)    <-- ATOMIC SWAP WORD WITH ACQUIRE
   0x0000000080000c36 <+30>:	bnez	a5,0x80000c32 <acquire+26> <-- SPIN LOOP IF LOCKED
   0x0000000080000c38 <+32>:	jal	0x800018be <mycpu>
   0x0000000080000c3c <+36>:	sd	a0,16(s1)             <-- RECORD HOLDING CPU
   0x0000000080000c3e <+38>:	ld	ra,24(sp)
   0x0000000080000c40 <+40>:	ld	s0,16(sp)
   0x0000000080000c42 <+42>:	ld	s1,8(sp)
   0x0000000080000c44 <+44>:	addi	sp,sp,32
   0x0000000080000c46 <+46>:	ret
   0x0000000080000c48 <+48>:	auipc	a0,0x6
   0x0000000080000c4c <+52>:	addi	a0,a0,1024 # 0x80007048
   0x0000000080000c50 <+56>:	jal	0x8000083a <panic>
End of assembler dump.
```
- **What to Say (Vidit)**:
> *"Look at offset +26 in GDB: amoswap.w.aq a5, a4, (s1)! It writes 1 from a4 into lk->locked at (s1), and loads the old value into a5 in a single indivisible bus transaction. If a5 was 0, the lock was free, so bnez a5 at +30 fails and the CPU enters the critical section. If a5 was 1, bnez a5 jumps back to +26—the CPU spins! The .aq suffix enforces Acquire Semantics: no memory access inside the critical section can be reordered before this instruction."*
- **Under The Hood**:
> RISC-V `.aq` acts as a one-way memory barrier preventing memory operations inside the critical section from hoisting outside.

### Step 2.5: Code Walkthrough — release() in kernel/spinlock.c
- **Terminal 2 (Right - Host / Editor)**:
```bash
sed -n '45,75p' kernel/spinlock.c
```
- **Expected Code Output**:
```c
void
release(struct spinlock *lk)
{
  if (!holding(lk))
    panic("release");

  lk->cpu = 0;

  // Release the lock, equivalent to lk->locked = 0.
  //
  // This code doesn't use a C assignment, since the C standard
  // implies that an assignment might be implemented with
  // multiple store instructions.
  //
  // On RISC-V, __atomic_store_n turns into a single atomic store:
  //   s1 = &lk->locked
  //   sw zero,0(s1)
  //
  // The __ATOMIC_RELEASE argument to __atomic_store_n tells the
  // the C compiler and the CPU to not move loads or stores past
  // this point, to ensure that all the stores in the critical
  // section are visible to other CPUs before the lock is released,
  // and that loads in the critical section occur strictly before
  // the lock is released.
  //
  // On RISC-V, this generates a fence instruction before the store:
  //   fence rw,w
  __atomic_store_n(&lk->locked, 0, __ATOMIC_RELEASE);

  pop_off();
}
```
- **What to Say (Vidit)**:
> *"When the critical section finishes, release() executes: It clears lk->cpu = 0; emits fence rw,w to ensure all prior writes are globally committed; clears lk->locked = 0 using __atomic_store_n with release semantics; and calls pop_off() to restore the CPU's interrupt state."*

### Step 2.6: GDB Disassembly of release() & Hardware Memory Barrier
- **Terminal 2 (Right - GDB / Host)**:
```bash
riscv64-elf-gdb -batch -ex "file kernel/kernel" -ex "disassemble release"
```
- **Expected GDB Disassembly**:
```text
The target architecture is set to "riscv:rv64".
.gdbinit:4: Error in sourced command file:
could not connect: Operation timed out.
Dump of assembler code for function release:
   0x0000000080000c9c <+0>:	addi	sp,sp,-32
   0x0000000080000c9e <+2>:	sd	ra,24(sp)
   0x0000000080000ca0 <+4>:	sd	s0,16(sp)
   0x0000000080000ca2 <+6>:	sd	s1,8(sp)
   0x0000000080000ca4 <+8>:	addi	s0,sp,32
   0x0000000080000ca6 <+10>:	mv	s1,a0
   0x0000000080000ca8 <+12>:	jal	0x80000bb2 <holding>
   0x0000000080000cac <+16>:	beqz	a0,0x80000cc8 <release+44>
   0x0000000080000cae <+18>:	sd	zero,16(s1)           <-- CLEAR lk->cpu
   0x0000000080000cb2 <+22>:	fence	rw,w                  <-- HARDWARE MEMORY BARRIER
   0x0000000080000cb6 <+26>:	sw	zero,0(s1)            <-- CLEAR lk->locked = 0
   0x0000000080000cba <+30>:	jal	0x80000c54 <pop_off>  <-- RESTORE INTERRUPT STATE
   0x0000000080000cbe <+34>:	ld	ra,24(sp)
   0x0000000080000cc0 <+36>:	ld	s0,16(sp)
   0x0000000080000cc2 <+38>:	ld	s1,8(sp)
   0x0000000080000cc4 <+40>:	addi	sp,sp,32
   0x0000000080000cc6 <+42>:	ret
   0x0000000080000cc8 <+44>:	auipc	a0,0x6
   0x0000000080000ccc <+48>:	addi	a0,a0,936 # 0x80007070
   0x0000000080000cd0 <+52>:	jal	0x8000083a <panic>
End of assembler dump.
```
- **What to Say (Vidit)**:
> *"Look at line +22 in GDB: fence rw,w! This memory barrier guarantees that all writes from the critical section are globally committed to memory before sw zero, 0(s1) clears the lock bit. To explain how interrupts are managed safely, I hand over to Devarsh Patel."*

---

## SECTION 3: PARTICIPANT 3 — DEVARSH PATEL (24BCT0267)
**Topic**: Nested Interrupt Invariants (`push_off`/`pop_off`), Complete Race Elimination, Benchmark Verification & Grand Finale  
**Responsible Functions & Commands**: `push_off()`, `pop_off()`, `mycpu()->noff`, `racetest locked`, `racetest`, `racetest 2 500 1`

- **Opening Dialogue (Devarsh)**:
> *"Thank you, Vidit. Respected professors and examiners, I am Devarsh Patel, registration number 24BCT0267. Why must spinlocks disable interrupts? If CPU 0 holds a spinlock and a timer interrupt fires on CPU 0, the CPU suspends the thread and enters trap.c. If the interrupt handler tries to acquire the same lock, CPU 0 deadlocks on itself—it cannot resume the thread to release the lock, and the handler cannot proceed. The system hangs permanently! Therefore, xv6 enforces an absolute invariant: Every spinlock acquisition disables interrupts on that CPU! Let us inspect how xv6 manages nested locks without prematurely re-enabling interrupts."*

### Step 3.1: Code Walkthrough — Per-CPU Interrupt State in kernel/proc.h
- **Terminal 2 (Right - Host / Editor)**:
```bash
sed -n '21,27p' kernel/proc.h
```
- **Expected Code Output**:
```c
// Per-CPU state.
struct cpu {
  struct proc *proc;      // The process running on this cpu, or null.
  struct context context; // swtch() here to enter scheduler().
  int noff;               // Depth of push_off() nesting.
  int intena;             // Were interrupts enabled before push_off()?
};
```
- **What to Say (Devarsh)**:
> *"In kernel/proc.h, each core has its own struct cpu tracking noff (nesting depth) and intena (original interrupt state). If Function A acquires Lock 1, and calls Function B which acquires and releases Lock 2, releasing Lock 2 must NOT turn interrupts back on while Lock 1 is still held!"*

### Step 3.2: Code Walkthrough — push_off() and pop_off() in kernel/spinlock.c
- **Terminal 2 (Right - Host / Editor)**:
```bash
sed -n '91,115p' kernel/spinlock.c
```
- **Expected Code Output**:
```c
void
push_off(void)
{
  // disable interrupts to prevent an involuntary context
  // switch while using mycpu().
  uint64 flags = rc_sstatus(SSTATUS_SIE);
  int old = !!(flags & SSTATUS_SIE);

  if (mycpu()->noff == 0)
    mycpu()->intena = old;
  mycpu()->noff += 1;
}

void
pop_off(void)
{
  struct cpu *c = mycpu();
  if (intr_get())
    panic("pop_off - interruptible");
  if (c->noff < 1)
    panic("pop_off");
  c->noff -= 1;
  if (c->noff == 0 && c->intena)
    intr_on();
}
```
- **What to Say (Devarsh)**:
> *"push_off() saves the original interrupt state in intena only on the very first lock (noff == 0), and increments noff. pop_off() decrements noff, and only re-enables interrupts (intr_on()) when noff returns to zero!"*
- **Under The Hood**:
> `rc_sstatus` reads `SSTATUS_SIE`, and `intr_off()` clears the `SIE` bit in `sstatus` using `csrrci`.

### Step 3.3: Code Walkthrough — Synchronized Critical Section in kernel/race.c
- **Terminal 2 (Right - Host / Editor)**:
```bash
sed -n '59,71p' kernel/race.c
```
- **Expected Code Output**:
```c
  for (int i = 0; i < iterations; i++) {
    if (use_lock) {
      // Synchronized critical section using xv6 spinlock
      acquire(&shared_res.lock);

      volatile int temp = shared_res.counter;
      for (volatile int d = 0; d < 30; d++)
        ;
      shared_res.counter = temp + 1;
      shared_res.total_ops++;

      release(&shared_res.lock);
    } else {
```
- **What to Say (Devarsh)**:
> *"When use_lock == 1, the entire read-modify-write sequence is wrapped between acquire(&shared_res.lock) and release(&shared_res.lock). Let us execute this live and observe the results!"*

### Step 3.4: Execute Live Synchronized Benchmark (racetest locked)
- **Terminal 1 (Left - QEMU Shell)**:
```bash
racetest locked
```
- **Expected Screen Output**:
```text
$ racetest locked

############################################################
#  xv6 MULTIPROCESSOR RACE CONDITION & SPINLOCK SUITE      #
#  Team: WindowsXP | Tejas, Vidit, Devarsh                 #
############################################################

============================================================
[SYNCHRONIZED TEST] Mode: xv6 Spinlock (acquire / release)
Protection: Mutual Exclusion ENABLED
Configuration: 4 child processes x 1000 iterations
Expected Counter Result: 4000
------------------------------------------------------------
Spawning 4 concurrent processes across CPUs...
Execution Complete. Reading final shared kernel counter...
------------------------------------------------------------
  >> Expected Value  : 4000
  >> Actual Counter  : 4000
  >> Lost Updates    : 0 (0% data loss)
------------------------------------------------------------
VERDICT: PERFECT MUTUAL EXCLUSION!
xv6 Spinlock eliminated race condition. 100% updates preserved.
============================================================
```
- **What to Say (Devarsh)**:
> *"Look at the terminal output! Expected: 4,000; Actual: 4,000; Lost Updates: 0 (0% data loss!). The xv6 spinlock has completely eliminated the race condition!"*

### Step 3.5: Execute Automated Full Comparative Benchmark (racetest)
- **Terminal 1 (Left - QEMU Shell)**:
```bash
racetest
```
- **Expected Screen Output**:
```text
$ racetest

############################################################
#  xv6 MULTIPROCESSOR RACE CONDITION & SPINLOCK SUITE      #
#  Team: WindowsXP | Tejas, Vidit, Devarsh                 #
############################################################

Running automated comprehensive benchmark (4 processes x 1000 ops)...

============================================================
[RACE CONDITION TEST] Mode: Unlocked (Concurrent Read-Modify-Write)
Protection: NONE (Vulnerable to SMP Race Window)
Configuration: 4 child processes x 1000 iterations
Expected Counter Result: 4000
------------------------------------------------------------
Spawning 4 concurrent processes across CPUs...
Execution Complete. Reading final shared kernel counter...
------------------------------------------------------------
  >> Expected Value  : 4000
  >> Actual Counter  : 1000
  >> Lost Updates    : 3000 (75% data loss)
------------------------------------------------------------
VERDICT: RACE CONDITION CONFIRMED!
Interleaved memory access on multi-core CPU caused 3000 lost updates.
============================================================

============================================================
[SYNCHRONIZED TEST] Mode: xv6 Spinlock (acquire / release)
Protection: Mutual Exclusion ENABLED
Configuration: 4 child processes x 1000 iterations
Expected Counter Result: 4000
------------------------------------------------------------
Spawning 4 concurrent processes across CPUs...
Execution Complete. Reading final shared kernel counter...
------------------------------------------------------------
  >> Expected Value  : 4000
  >> Actual Counter  : 4000
  >> Lost Updates    : 0 (0% data loss)
------------------------------------------------------------
VERDICT: PERFECT MUTUAL EXCLUSION!
xv6 Spinlock eliminated race condition. 100% updates preserved.
============================================================
```
- **What to Say (Devarsh)**:
> *"When run head-to-head in our automated comparison: Without locking: 3,000 lost updates and 75% data corruption. With xv6 spinlocks: Zero lost updates and 100.0% data integrity! This side-by-side contrast provides conclusive empirical proof of spinlock mutual exclusion."*

### Step 3.6: Execute Parametric Synchronized Test with 2 Processes
- **Terminal 1 (Left - QEMU Shell)**:
```bash
racetest 2 500 1
```
- **Expected Screen Output**:
```text
$ racetest 2 500 1

############################################################
#  xv6 MULTIPROCESSOR RACE CONDITION & SPINLOCK SUITE      #
#  Team: WindowsXP | Tejas, Vidit, Devarsh                 #
############################################################

============================================================
[SYNCHRONIZED TEST] Mode: xv6 Spinlock (acquire / release)
Protection: Mutual Exclusion ENABLED
Configuration: 2 child processes x 500 iterations
Expected Counter Result: 1000
------------------------------------------------------------
Spawning 2 concurrent processes across CPUs...
Execution Complete. Reading final shared kernel counter...
------------------------------------------------------------
  >> Expected Value  : 1000
  >> Actual Counter  : 1000
  >> Lost Updates    : 0 (0% data loss)
------------------------------------------------------------
VERDICT: PERFECT MUTUAL EXCLUSION!
xv6 Spinlock eliminated race condition. 100% updates preserved.
============================================================
```
- **What to Say (Devarsh)**:
> *"In the 2-process trial, where unlocked mode suffered 500 lost updates, spinlock protection preserves all 1,000 increments perfectly."*

### Step 3.7: Grand Finale & Architectural Conclusion
- **Terminal 1 (Left) & Terminal 2 (Right)**:
```bash
echo '=== PRESENTATION SUMMARY COMPLETE ==='
```
- **Expected Screen Output**:
```text
$ echo '=== PRESENTATION SUMMARY COMPLETE ==='
'=== PRESENTATION SUMMARY COMPLETE ==='
$ 
```
- **What to Say (Devarsh)**:
> *"To conclude, we have demonstrated the three fundamental pillars of operating system concurrency: 1. Concurrency Hazards: Unprotected read-modify-write sequences (lw, addiw, sw) allow race windows where concurrent CPU cores overwrite each other's memory updates. 2. Hardware Atomics: Software locks require atomic hardware primitives (amoswap.w.aq on RISC-V) and memory barriers (fence rw,w) to guarantee atomicity and prevent memory reordering. 3. Interrupt Safety Invariant: Spinlocks must disable interrupts on the holding core using nested depth tracking (push_off/pop_off) to prevent unrecoverable single-core recursive deadlocks. Tejas, Vidit, and I are now ready to take any questions from the evaluators. Thank you!"*

---

## SECTION 4: COMPARATIVE EXPERIMENTAL RESULTS MATRIX

| Metric / Architectural Parameter | Unlocked Benchmark (Test 1) | Spinlock-Protected (Test 2) |
| :--- | :--- | :--- |
| **Concurrency Control Mode** | Unprotected Read-Modify-Write | xv6 Spinlock (`acquire` / `release`) |
| **Symmetric Multiprocessing (SMP)** | `CPUS=2` (2 Active RISC-V Harts) | `CPUS=2` (2 Active RISC-V Harts) |
| **Concurrent Processes Spawned** | 4 Child Processes (forked) | 4 Child Processes (forked) |
| **Increments per Process** | 1,000 Iterations | 1,000 Iterations |
| **Expected Total Counter** | 4,000 | 4,000 |
| **Actual Recorded Counter** | **1,000** | **4,000** |
| **Lost Updates (Collisions)** | **3,000 Lost Increments** | **0 (Zero Lost Increments)** |
| **Data Corruption Rate** | **75.0% Data Loss** | **0.0% (100% Data Integrity)** |
| **Hardware Atomic Instruction** | None (Uncoordinated `lw`/`sw`) | `amoswap.w.aq a5, a4, (s1)` |
| **Hardware Memory Barrier** | None | `fence rw,w` |
| **Interrupt Safety Mechanism** | None (Vulnerable to Preemption) | `push_off()` / `pop_off()` Nesting |

---

## SECTION 5: EXHAUSTIVE VIVA & DEFENSE PREPARATION (EXAMINER Q&A)

### Q1: What is the fundamental difference between a spinlock and a sleeplock in xv6? When should each be used?
> **Answer**: A spinlock keeps the CPU actively executing in a tight polling loop (`while(amoswap...)`) until the lock becomes free. It disables interrupts on the local core via `push_off()` and strictly prohibits yielding or sleeping (`sched()` explicitly checks `mycpu()->noff == 1`; otherwise it panics). Spinlocks are designed for very short critical sections (e.g. updating process state, manipulating free lists, buffer cache pointers) where holding time is negligible.  
> A sleeplock (`kernel/sleeplock.c`) puts the calling process to sleep (`sleep()`), yielding the CPU to the scheduler so other processes can execute while waiting. Sleeplocks leave interrupts enabled and are used for long-duration operations involving disk I/O or pipe waits where spinning would waste millions of CPU cycles.

### Q2: Why does xv6 panic if a kernel thread tries to sleep (`sleep()`) or yield (`yield()`) while holding a spinlock?
> **Answer**: If Process A holds a spinlock on CPU 0 and yields or goes to sleep:
> 1. CPU 0 is switched to Process B.
> 2. If Process B (or another process on CPU 1) attempts to acquire that same spinlock, it will spin continuously.
> 3. If Process B is running on CPU 0, Process A cannot run to release the lock because Process B is monopolizing CPU 0 spinning.
> 4. Even worse, if Process A was holding `p->lock` or a shared subsystem lock, deadlocks propagate across all cores.  
> To prevent this, xv6's `sched()` asserts: `if(mycpu()->noff != 1) panic("sched locks");` (where `noff == 1` accounts only for the scheduler's own `p->lock`).

### Q3: What is the purpose of the `.aq` suffix in `amoswap.w.aq`? What would go wrong without it?
> **Answer**: The `.aq` suffix denotes Acquire Semantics in the RISC-V memory consistency model. Modern superscalar out-of-order processors and memory controllers can reorder read and write instructions for performance. Without `.aq`, memory accesses belonging inside the critical section could be speculatively fetched or executed before the lock is officially acquired, allowing another core to observe or overwrite data concurrently, violating mutual exclusion!

### Q4: Why does `release()` require `fence rw,w` before clearing the lock word?
> **Answer**: `fence rw,w` is a hardware memory barrier instruction. It dictates that all Device and Memory Read and Write operations preceding the fence must be committed and visible to all other CPU cores before the Write operation following the fence (`sw zero, 0(s1)`) is executed. Without this fence, a processor might flush the lock release to memory before the modifications made inside the critical section reach the cache coherency bus. Another CPU acquiring the lock would then read stale data.

### Q5: Can a spinlock be acquired recursively by the same CPU? What happens in xv6?
> **Answer**: No! xv6 spinlocks are non-recursive. If a CPU holding lock `lk` attempts to call `acquire(lk)` again, xv6 detects this via `holding(lk)`: `if(holding(lk)) panic("acquire");`. If this check did not exist, `amoswap.w.aq` would see `lk->locked == 1` and spin forever waiting for the lock to be released, which will never happen because the only core capable of releasing it is stuck spinning!

### Q6: Why does `push_off()` record `intena` only when `noff == 0`?
> **Answer**: When locks are nested:
> - Lock 1 is acquired when interrupts might be ON (`intena = 1`). `noff` increments from 0 to 1.
> - Lock 2 is acquired. Interrupts are ALREADY off due to Lock 1! `noff` increments from 1 to 2.  
> If `push_off()` recorded `intena` when `noff == 1`, it would record `intena = 0` (interrupts disabled). Then, when Lock 2 was released, `pop_off()` would see `intena = 0` and fail to restore interrupts when Lock 1 is finally released! Recording only at `noff == 0` preserves the true initial interrupt state of the processor before any locks were taken.

### Q7: Why are spinlocks ineffective on a single-core uniprocessor (`CPUS=1`) without preemption?
> **Answer**: On a single core without preemption, if a thread attempts to acquire a held spinlock, no other thread or core can run to release it. The CPU will spin indefinitely, resulting in a permanent hang. On uniprocessors, mutual exclusion is achieved simply by disabling interrupts (`intr_off()`). Spinlocks are specifically designed for symmetric multiprocessor (SMP) architectures where the lock holder is concurrently executing on a different physical CPU.

---

## SECTION 6: COMPLETE KERNEL & USER SOURCE CODE APPENDIX

### 6.1 kernel/race.c (Shared Kernel Resource & Spinlock Implementation)
```c
""" + race_c + """
```

### 6.2 user/racetest.c (Benchmarking & Demonstration Suite)
```c
""" + racetest_c + """
```
"""
    with open(output_path, "w") as f:
        f.write(md)

if __name__ == "__main__":
    build_document()
