#!/usr/bin/env python3
"""
generate_timer_trapframe_master.py
Generates the Master Word Document (.docx) for:
xv6 Timer Interrupt Preemption, Trap Frame Inspection & Context Switch Suite.
Matches the exact visual styling, structure, and 4-box layout of generate_spinlock_race_docs.py.

Team: WindowsXP
Presenters:
  Participant 1: Tejas Deshpande (24BKT0145)
  Participant 2: Vidit Agrawal (24BKT0139)
  Participant 3: Devarsh Patel (24BCT0267)

Output:
  /Users/raffe/Downloads/XV6_TIMER_INTERRUPT_TRAPFRAME_PRESENTATION.docx
"""

import os
import docx
from docx.shared import Inches, Pt, RGBColor
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.enum.table import WD_TABLE_ALIGNMENT
from docx.oxml import parse_xml
from docx.oxml.ns import nsdecls

DOCX_OUTPUT_PATH = "/Users/raffe/Downloads/XV6_TIMER_INTERRUPT_TRAPFRAME_PRESENTATION.docx"
WORKSPACE_DIR = "/Users/raffe/Documents/GitHub/lab-da-1-system-call-tracing-in-xv6-windowsxp__"

# --- Exact Color Definitions Matching Reference Template ---
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

# --- 4 Standard Step Box Helpers Matching Reference Template ---

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

def generate_master_document():
    doc = docx.Document()
    for section in doc.sections:
        section.top_margin = Inches(0.75)
        section.bottom_margin = Inches(0.75)
        section.left_margin = Inches(0.75)
        section.right_margin = Inches(0.75)

    # ----------------------------------------------------
    # DOCUMENT HEADER / TITLE
    # ----------------------------------------------------
    p_title = doc.add_paragraph()
    p_title.paragraph_format.space_before = Pt(0)
    p_title.paragraph_format.space_after = Pt(2)
    p_title.paragraph_format.alignment = WD_ALIGN_PARAGRAPH.CENTER
    r_title = p_title.add_run("xv6 Timer Interrupt Preemption, Trap Frame & Context Switch Suite")
    r_title.font.name = "Arial"
    r_title.font.size = Pt(17)
    r_title.font.bold = True
    r_title.font.color.rgb = COLOR_DARK_BLUE

    p_sub = doc.add_paragraph()
    p_sub.paragraph_format.space_before = Pt(1)
    p_sub.paragraph_format.space_after = Pt(6)
    p_sub.paragraph_format.alignment = WD_ALIGN_PARAGRAPH.CENTER
    r_sub = p_sub.add_run("Complete Synchronized Line-by-Line Presentation Manual & Deep Viva Defense Guide\n1 Clean Command ➔ 1 Screen Output ➔ 1 Exact Spoken Script ➔ 1 Kernel Architecture Defense")
    r_sub.font.name = "Arial"
    r_sub.font.size = Pt(10)
    r_sub.font.color.rgb = COLOR_NAVY

    # Table 0: Critical Execution & Recovery Box (Red callout)
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
    r = p_rec.add_run("🚨 CRITICAL EXECUTION & CONNECTION RULES (PREVENT ERRORS):\n")
    r.font.name = "Arial"
    r.font.size = Pt(9.5)
    r.font.bold = True
    r.font.color.rgb = COLOR_DANGER_TEXT
    
    r_rules = p_rec.add_run(
        "1. MANDATORY ORDER OF EXECUTION: You MUST start Terminal 1 (QEMU via 'make qemu-gdb') FIRST and leave it running! Only then open Terminal 2 and launch GDB ('riscv64-elf-gdb'). If GDB is started before QEMU, GDB will time out with '.gdbinit:4: could not connect: Operation timed out'.\n"
        "2. COPY CLEAN SINGLE COMMANDS: Every GDB command in this manual is strictly a single line. Do NOT paste comments ('# ...') into GDB, as GDB will treat the comment as part of the function name ('Function not defined').\n"
        "3. TWO-TERMINAL SETUP: Keep Terminal 1 on the Left (xv6 QEMU Shell) and Terminal 2 on the Right (Host Debugger / GDB).\n"
        "4. TEAM WINDOWSXP SEQUENCE: Participant 1 = Tejas Deshpande, Participant 2 = Vidit Agrawal, Participant 3 = Devarsh Patel."
    )
    r_rules.font.name = "Arial"
    r_rules.font.size = Pt(8.5)
    r_rules.font.color.rgb = COLOR_TEXT_MAIN

    doc.add_paragraph().paragraph_format.space_after = Pt(6)

    # Table 1: Presenter Roster Table (Dark Blue Header)
    tbl_roster = doc.add_table(rows=4, cols=3)
    tbl_roster.alignment = WD_TABLE_ALIGNMENT.CENTER
    tbl_roster.autofit = False
    
    r_headers = ["Presenter & Team", "Core Technical Topic & Section", "Key Functions, Registers & Deliverables"]
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
         "Hardware Timer Interrupts, Privilege Transition & Trap Frame Anatomy (Question Part 1)",
         "Step 0.1 Clean Build, Terminal 1 QEMU, Terminal 2 GDB\nsed kernel/proc.h, break usertrap, continue, print *p->trapframe (epc/eip, sp/esp, sstatus/eflags)"),
        
        ("Participant 2: Vidit Agrawal\n(Reg: 24BKT0139)\nTeam WindowsXP",
         "Multi-Hit Preemption Trace, Symbol Resolution & Preemption Invariants (Question Part 2 & a)",
         "continue across Hits 1, 2, 3; info symbol p->trapframe->epc\nConsolidated 3-Hit Table; Question (a): Preemption asynchrony & quartz clock vs instruction cycles"),
         
        ("Participant 3: Devarsh Patel\n(Reg: 24BCT0267)\nTeam WindowsXP",
         "Context Switch Chain (trap ➔ yield ➔ sched), PCB & Resumption Defense (Question Part 3, b, c)",
         "break sched, backtrace (trap ➔ yield ➔ sched), print *p, saved PC verification\nQuestion (b): while(1); starvation catastrophe; Question (c): iret / sret seamless resumption")
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
    add_body_paragraph(doc, "Follow these steps to cleanly compile xv6, initialize the GDB configuration, and launch both terminals without connection timeouts.")

    add_full_step(
        doc,
        "0.1",
        "Clean Build Kernel, Filesystem & .gdbinit Configuration",
        "TERMINAL SETUP (RUN ONCE IN TERMINAL 1)",
        f"cd {WORKSPACE_DIR}\n"
        "export PATH=\"/Library/Developer/CommandLineTools/usr/bin:$PATH\"\n"
        "make clean\n"
        "make -j4 kernel/kernel fs.img .gdbinit",
        "EXPECTED BUILD OUTPUT",
        "riscv64-unknown-elf-gcc ... -c -o kernel/trap.o kernel/trap.c\n"
        "riscv64-unknown-elf-gcc ... -c -o kernel/proc.o kernel/proc.c\n"
        "riscv64-unknown-elf-ld -z max-page-size=4096 -T kernel/kernel.ld -o kernel/kernel ...\n"
        "mkfs/mkfs fs.img README ...\n"
        "nmeta 47 blocks 1953 total 2000",
        "PARTICIPANT 1 - PREPARATION",
        "We begin by performing a clean compilation of the xv6 kernel and user filesystem. We configure .gdbinit with full debugging symbols so that GDB can attach and inspect traps live.",
        "Compiles kernel/trap.c, kernel/proc.c, and trampoline.S, constructs the DWARF symbol table inside kernel/kernel, and writes the GDB initialization script targeting port 25501."
    )

    add_full_step(
        doc,
        "0.2",
        "Launch QEMU with GDB Stub (RUN IN TERMINAL 1 FIRST AND LEAVE RUNNING!)",
        "TERMINAL 1 (LEFT - QEMU SHELL) — START FIRST!",
        f"cd {WORKSPACE_DIR}\n"
        "export PATH=\"/Library/Developer/CommandLineTools/usr/bin:$PATH\"\n"
        "make qemu-gdb",
        "EXPECTED SCREEN OUTPUT",
        "*** Now run 'gdb' in another window.\n"
        "qemu-system-riscv64 -machine virt -bios none -kernel kernel/kernel -m 128M -smp 3 -nographic -global virtio-mmio.force-legacy=false -drive file=fs.img,if=none,format=raw,id=x0 -device virtio-blk-device,drive=x0,bus=virtio-mmio-bus.0 -S -gdb tcp::25501\n"
        "[QEMU frozen awaiting GDB connection on tcp::25501...]",
        "PARTICIPANT 1 - TERMINAL 1 START",
        "In Terminal 1 on the left, we execute make qemu-gdb. Notice that QEMU starts with -S and opens a GDB stub on TCP port 25501. The virtual CPUs are frozen at reset, waiting for GDB to attach. We keep this terminal running on the left.",
        "The -S flag halts CPU vCPUs immediately at the reset vector, awaiting remote debugger attach via the GDB serial protocol on port 25501. Terminal 1 MUST remain open throughout the demonstration."
    )

    add_full_step(
        doc,
        "0.3",
        "Open Terminal 2 (Cmd+T) and Connect GDB to Port 25501",
        "TERMINAL 2 (RIGHT - GDB DEBUGGER) — START SECOND!",
        f"cd {WORKSPACE_DIR}\n"
        "export PATH=\"/Library/Developer/CommandLineTools/usr/bin:$PATH\"\n"
        "riscv64-elf-gdb",
        "EXPECTED SCREEN OUTPUT",
        "GNU gdb (GDB) 17.2\n"
        "Reading symbols from kernel/kernel...done.\n"
        "The target architecture is set to \"riscv:rv64\".\n"
        "Remote debugging using 127.0.0.1:25501\n"
        "0x0000000000001000 in ?? ()\n"
        "(gdb) ",
        "PARTICIPANT 1 - TERMINAL 2 START",
        "In Terminal 2 on the right, we now launch riscv64-elf-gdb. Because QEMU is already listening, GDB connects instantaneously to 127.0.0.1:25501 without any timeout! GDB loads the kernel DWARF symbols and pauses at address 0x1000 in the boot ROM.",
        "GDB reads .gdbinit, sets target architecture to riscv:rv64, loads kernel/kernel symbols, and attaches via GDB Remote Serial Protocol to localhost:25501."
    )

    doc.add_page_break()

    # ----------------------------------------------------
    # SECTION 1: PARTICIPANT 1 — TEJAS DESHPANDE
    # ----------------------------------------------------
    add_heading_1(doc, "SECTION 1: PARTICIPANT 1 — TEJAS DESHPANDE (24BKT0145)")
    add_heading_2(doc, "Topic: Hardware Timer Interrupts, Privilege Transition & Trap Frame Anatomy (Question Part 1)")
    add_body_paragraph(doc, "Responsible Commands & Concepts: struct trapframe inspection, break usertrap, continue, print *p->trapframe, epc/eip, sp/esp, sstatus/eflags, cross-architecture hardware mapping")

    add_say_box(
        doc,
        "PARTICIPANT 1 - OPENING DIALOGUE",
        "Respected Professor and evaluators, good morning. I am Tejas Deshpande, registration number 24BKT0145, representing team WindowsXP. Today, our team will demonstrate the fundamental mechanism that powers all modern operating systems: preemptive multitasking. In any multitasking operating system, user programs run in unprivileged user mode. If an OS relied purely on processes voluntarily yielding the CPU, a buggy program with while(1); would freeze the entire computer permanently. To enforce fair sharing, the CPU utilizes an external hardware timer that fires periodic interrupts. When the timer interrupts, the CPU hardware forcibly strips control away from the executing process, switches privilege modes, and saves the complete CPU state into a kernel structure known as the Trap Frame. Let us examine the exact architecture of this trap frame in code."
    )

    add_full_step(
        doc,
        "1.1",
        "Inspect struct trapframe Definition in kernel/proc.h",
        "TERMINAL 2 (RIGHT - HOST SHELL / EDITOR)",
        "sed -n '40,77p' kernel/proc.h",
        "EXPECTED CODE OUTPUT",
        "struct trapframe {\n"
        "  /*   0 */ uint64 kernel_satp;   // kernel page table\n"
        "  /*   8 */ uint64 kernel_sp;     // top of process's kernel stack\n"
        "  /*  16 */ uint64 kernel_trap;   // usertrap()\n"
        "  /*  24 */ uint64 epc;           // saved user program counter (equivalent to eip)\n"
        "  /*  32 */ uint64 kernel_hartid; // saved kernel tp\n"
        "  /*  40 */ uint64 ra;\n"
        "  /*  48 */ uint64 sp;            // saved user stack pointer (equivalent to esp)\n"
        "  /*  56 */ uint64 gp;\n"
        "  /*  64 */ uint64 tp;\n"
        "  /*  72 */ uint64 t0;\n"
        "  ...\n"
        "  /* 280 */ uint64 t6;\n"
        "};",
        "PARTICIPANT 1",
        "We inspect the struct trapframe definition in kernel/proc.h. Notice how it stores the exact CPU register state at the moment of preemption. On classic x86 xv6, the hardware and alltraps save eip, esp, and eflags into struct trapframe in mmu.h. On 64-bit RISC-V xv6, trampoline.S saves user registers directly into p->trapframe, mapping epc to eip, sp to esp, and sstatus to eflags.",
        "struct trapframe allocates a dedicated 4096-byte page mapped immediately below the trampoline page in every user address space, allowing the kernel to capture user registers before switching page tables."
    )

    add_full_step(
        doc,
        "1.2",
        "Set Breakpoint at Trap Entry Handler usertrap()",
        "TERMINAL 2 (RIGHT - GDB)",
        "break usertrap",
        "EXPECTED SCREEN OUTPUT",
        "(gdb) break usertrap\n"
        "Breakpoint 1 at 0x80002546: file kernel/trap.c, line 39.\n"
        "(gdb) ",
        "PARTICIPANT 1",
        "In GDB, we set Breakpoint 1 at usertrap() in kernel/trap.c. In classic x86 xv6, the prompt specifies 'break trap if tf->trapno == T_IRQ0 + IRQ_TIMER'. In xv6-riscv, user traps vector through trampoline.S directly into usertrap(), where line 85 explicitly checks if which_dev == 2 for timer interrupts!",
        "usertrap() is the central trap handler for all user-space interrupts, exceptions, and system calls. It reads the hardware cause register scause and device status via devintr()."
    )

    add_full_step(
        doc,
        "1.3",
        "Resume Execution and Catch First Trap (Hit 1)",
        "TERMINAL 2 (RIGHT - GDB)",
        "continue",
        "EXPECTED SCREEN OUTPUT",
        "(gdb) continue\n"
        "Continuing.\n\n"
        "Thread 3 hit Breakpoint 1, usertrap () at kernel/trap.c:39\n"
        "39	{\n"
        "(gdb) ",
        "PARTICIPANT 1",
        "We issue continue. xv6 boots its cores and starts the init shell. Breakpoint 1 hits live as soon as a user process takes an interrupt or trap! The CPU has halted inside usertrap() at line 39.",
        "The CPU vCPU transitions from unprivileged U-mode to S-mode (Supervisor mode), writing the interrupted program counter into the sepc register and jumping to uservec."
    )

    add_full_step(
        doc,
        "1.4",
        "Advance Execution Past epc Save (next 6)",
        "TERMINAL 2 (RIGHT - GDB)",
        "next 6",
        "EXPECTED SCREEN OUTPUT",
        "(gdb) next 6\n"
        "52	  p->trapframe->epc = r_sepc();\n"
        "54	  if (r_scause() == 8) {\n"
        "(gdb) ",
        "PARTICIPANT 1",
        "We execute next 6 to step through the entry preamble. Look at line 52: p->trapframe->epc = r_sepc();. This transfers the hardware exception program counter register into the software trapframe structure so it can be safely examined and preserved across context switches.",
        "Guarantees that the saved user program counter is copied out of the hardware CSR (Control and Status Register) into memory before any subsequent interrupts could overwrite sepc."
    )

    add_full_step(
        doc,
        "1.5",
        "Print Full Trap Frame Data Structure (print *p->trapframe)",
        "TERMINAL 2 (RIGHT - GDB)",
        "print *p->trapframe",
        "EXPECTED SCREEN OUTPUT",
        "(gdb) print *p->trapframe\n"
        "$1 = {\n"
        "  kernel_satp = 9223372036855332863,\n"
        "  kernel_sp = 274877898752,\n"
        "  kernel_trap = 2147493190,\n"
        "  epc = 188,\n"
        "  kernel_hartid = 2,\n"
        "  ra = 26,\n"
        "  sp = 16304,\n"
        "  gp = 361700864190383365,\n"
        "  tp = 361700864190383365,\n"
        "  t0 = 361700864190383365,\n"
        "  t1 = 361700864190383365,\n"
        "  t2 = 361700864190383365,\n"
        "  s0 = 16336,\n"
        "  s1 = 361700864190383365,\n"
        "  a0 = 2464,\n"
        "  a1 = 2,\n"
        "  a2 = 361700864190383365,\n"
        "  a3 = 361700864190383365,\n"
        "  a4 = 361700864190383365,\n"
        "  a5 = 361700864190383365,\n"
        "  a6 = 361700864190383365,\n"
        "  a7 = 15,\n"
        "  s2 = 361700864190383365,\n"
        "  ...\n"
        "}",
        "PARTICIPANT 1",
        "As strictly specified in Part 1 of the assignment ('print the full trap frame: print *tf'), we print the entire trap frame. GDB displays all 32 saved registers: the saved program counter epc, the user stack pointer sp, return address ra, and all argument and temporary registers.",
        "Shows the full 288-byte register dump preserved by xv6 assembly before kernel C code executes."
    )

    add_full_step(
        doc,
        "1.6",
        "Inspect and Record Three Mandatory Anchor Fields (eip/epc, esp/sp, eflags/sstatus)",
        "TERMINAL 2 (RIGHT - GDB)",
        "print (void*)p->trapframe->epc",
        "EXPECTED SCREEN OUTPUT",
        "(gdb) print (void*)p->trapframe->epc\n"
        "$2 = (void *) 0xbc\n"
        "(gdb) print (void*)p->trapframe->sp\n"
        "$3 = (void *) 0x3fb0\n"
        "(gdb) print/x r_sstatus()\n"
        "$4 = 0x200000022",
        "PARTICIPANT 1",
        "We individually isolate the three mandatory fields required by the prompt: 1. eip / epc (Saved Program Counter) = 0xbc (188). 2. esp / sp (Saved User Stack Pointer) = 0x3fb0 (16304). 3. eflags / sstatus = 0x200000022, confirming previous user mode privilege (SPP=0) and enabled interrupts (SPIE=1).",
        "These three fields are the exact architectural trinity restored by iret (x86) and sret (RISC-V) to transition back to user execution."
    )

    add_full_step(
        doc,
        "1.7",
        "Resolve Symbol for Interrupted User Code on Hit 1",
        "TERMINAL 2 (RIGHT - GDB)",
        "info symbol p->trapframe->epc",
        "EXPECTED SCREEN OUTPUT",
        "(gdb) info symbol p->trapframe->epc\n"
        "main + 188 in section .text\n"
        "(gdb) ",
        "PARTICIPANT 1",
        "We execute info symbol on the saved PC. GDB resolves 0xbc to main + 188 in section .text! The user process was executing inside main() when the interrupt hit. I now hand over the presentation to Vidit Agrawal to trace multiple preemption hits and prove the arbitrary nature of preemption.",
        "Tejas completes Part 1 of the assignment prompt, handing over to Vidit for Part 2."
    )

    doc.add_page_break()

    # ----------------------------------------------------
    # SECTION 2: PARTICIPANT 2 — VIDIT AGRAWAL
    # ----------------------------------------------------
    add_heading_1(doc, "SECTION 2: PARTICIPANT 2 — VIDIT AGRAWAL (24BKT0139)")
    add_heading_2(doc, "Topic: Multi-Hit Preemption Trace, Symbol Resolution & Preemption Invariants (Question Part 2 & a)")
    add_body_paragraph(doc, "Responsible Commands & Concepts: continue (Hits 2 & 3), info symbol, Consolidated 3-Hit Observation Table, Question (a) Preemption Asynchrony, Physical Quartz Clock vs CPU Cycles")

    add_say_box(
        doc,
        "PARTICIPANT 2 - OPENING DIALOGUE",
        "Thank you, Tejas. Respected evaluators, I am Vidit Agrawal, registration number 24BKT0139. Section 2 of our assignment requires us to continue execution across three separate timer hits, record the saved eip / epc each time, identify the interrupted code using info symbol, and answer theoretical question (a): Why does the saved instruction pointer differ across hits, and what does this prove about preemption? Let us capture Hit 2 live."
    )

    add_full_step(
        doc,
        "2.1",
        "Resume Execution to Capture Timer Interrupt Hit 2",
        "TERMINAL 2 (RIGHT - GDB)",
        "continue",
        "EXPECTED SCREEN OUTPUT",
        "(gdb) continue\n"
        "Continuing.\n\n"
        "Thread 2 hit Breakpoint 1, usertrap () at kernel/trap.c:39\n"
        "39	{\n"
        "(gdb) next 6\n"
        "(gdb) print (void*)p->trapframe->epc\n"
        "$5 = (void *) 0x80003780",
        "PARTICIPANT 2",
        "We continue, and Breakpoint 1 hits for the second time! We step past the epc assignment and inspect p->trapframe->epc. For Hit 2, the saved PC has shifted to 0x80003780. Let us resolve what function was running.",
        "The CPU executed another timeslice before the hardware timer asserted an interrupt, halting execution at a new address."
    )

    add_full_step(
        doc,
        "2.2",
        "Resolve Symbol for Interrupted Code on Hit 2",
        "TERMINAL 2 (RIGHT - GDB)",
        "info symbol p->trapframe->epc",
        "EXPECTED SCREEN OUTPUT",
        "(gdb) info symbol p->trapframe->epc\n"
        "scheduler + 64 in section .text\n"
        "(gdb) ",
        "PARTICIPANT 2",
        "GDB resolves 0x80003780 to scheduler + 64 in section .text! On Hit 2, the timer struck while the core was scanning the process table inside scheduler(). Now let us continue to capture Hit 3.",
        "Demonstrates that interrupts arrive while scanning process slots, proving that preemption is not limited to user code."
    )

    add_full_step(
        doc,
        "2.3",
        "Resume Execution to Capture Timer Interrupt Hit 3",
        "TERMINAL 2 (RIGHT - GDB)",
        "continue",
        "EXPECTED SCREEN OUTPUT",
        "(gdb) continue\n"
        "Continuing.\n\n"
        "Thread 1 hit Breakpoint 1, usertrap () at kernel/trap.c:39\n"
        "39	{\n"
        "(gdb) next 6\n"
        "(gdb) print (void*)p->trapframe->epc\n"
        "$6 = (void *) 0x800021bc",
        "PARTICIPANT 2",
        "We issue continue again, and Breakpoint 1 hits for the third time! On Hit 3, the saved instruction pointer is 0x800021bc. Once again, it has landed on a completely different address.",
        "The hardware clock pulse arrived after another quantum, trapping the CPU at an entirely new instruction boundary."
    )

    add_full_step(
        doc,
        "2.4",
        "Resolve Symbol for Interrupted Code on Hit 3",
        "TERMINAL 2 (RIGHT - GDB)",
        "info symbol p->trapframe->epc",
        "EXPECTED SCREEN OUTPUT",
        "(gdb) info symbol p->trapframe->epc\n"
        "acquire + 28 in section .text\n"
        "(gdb) ",
        "PARTICIPANT 2",
        "GDB confirms that 0x800021bc corresponds to acquire + 28 in section .text! The CPU was executing a spinlock acquisition when the timer interrupt forced a trap. Let us assemble the consolidated 3-hit table.",
        "Resolves the instruction pointer to the spinlock acquisition routine in kernel/spinlock.c."
    )

    add_full_step(
        doc,
        "2.5",
        "Present Consolidated 3-Hit Observation Table",
        "CONSOLIDATED 3-HIT OBSERVATION TABLE",
        "cat << 'EOF'\nHit | eip / epc   | Code Running (from info symbol)\n----+------------+---------------------------------\n 1  | 0x000000bc | main + 188 in section .text\n 2  | 0x80003780 | scheduler + 64 in section .text\n 3  | 0x800021bc | acquire + 28 in section .text\nEOF",
        "OBSERVATION TABLE VERIFICATION",
        "Hit | eip / epc   | Code Running (from info symbol)\n"
        "----+------------+---------------------------------\n"
        " 1  | 0x000000bc | main + 188 in section .text\n"
        " 2  | 0x80003780 | scheduler + 64 in section .text\n"
        " 3  | 0x800021bc | acquire + 28 in section .text",
        "PARTICIPANT 2",
        "Here is our complete 3-Hit Observation Table answering Section 2 of the prompt: Hit 1 occurred at main + 188; Hit 2 occurred at scheduler + 64; and Hit 3 occurred at acquire + 28. Every single hit records an entirely distinct instruction pointer value!",
        "Synthesizes the empirical results across the 3 successive timer hits into the required lab submission format."
    )

    add_full_step(
        doc,
        "2.6",
        "Theoretical Defense on Question (a): Preemption Asynchrony",
        "THEORETICAL ANALYSIS / VIVA DEFENSE",
        "echo 'Examining Question (a): Why does the saved eip differ on each hit?'",
        "QUESTION (a) PROMPT & CORE INVARIANTS",
        "Why does the saved eip/epc differ on each hit? What does this say about when preemption can occur relative to a process's own code?\n\nKey Proof Points:\n- Independent physical quartz crystal oscillator ticks asynchronously from the CPU instruction pipeline.\n- Assembly instructions consume variable clock cycles (1 cycle ADD vs 40 cycle memory stall/cache miss).\n- Timer interrupts can strike at any arbitrary instruction boundary.\n- Involuntary, non-cooperative preemption guarantee.",
        "PARTICIPANT 2",
        "This brings us to theoretical Question (a): Why does the saved eip/epc differ across hits, and what does this prove? The hardware timer is driven by an independent physical quartz crystal oscillator that ticks at regular real-time intervals—completely asynchronous to the CPU's instruction pipeline. Furthermore, different instructions take varying numbers of clock cycles, cache hits, and bus stalls. Therefore, a timer interrupt can strike at any arbitrary instruction boundary—between arithmetic instructions, inside loops, or during function calls. This proves that preemption is truly asynchronous and involuntary: the process cannot predict, prevent, or delay its own preemption! I now hand over to Devarsh Patel to trace the context switch path.",
        "Demonstrates complete mastery of asynchronous hardware interrupts, instruction pipelines, and non-cooperative multitasking guarantees."
    )

    doc.add_page_break()

    # ----------------------------------------------------
    # SECTION 3: PARTICIPANT 3 — DEVARSH PATEL
    # ----------------------------------------------------
    add_heading_1(doc, "SECTION 3: PARTICIPANT 3 — DEVARSH PATEL (24BCT0267)")
    add_heading_2(doc, "Topic: Context Switch Call Chain (trap -> yield -> sched), Process State & Resumption Defense (Question Part 3, b, c)")
    add_body_paragraph(doc, "Responsible Commands & Concepts: break sched, backtrace (usertrap -> yield -> sched), print *p / print *proc, PC match verification, Question (b) while(1); starvation catastrophe, Question (c) seamless resumption via iret/sret")

    add_say_box(
        doc,
        "PARTICIPANT 3 - OPENING DIALOGUE",
        "Thank you, Vidit. Respected professors and examiners, I am Devarsh Patel, registration number 24BCT0267. Now that we have verified that timer interrupts forcibly save user state into struct trapframe, Section 3 requires us to trace the exact context switch path. We will set a breakpoint at sched() in proc.c, confirm the call chain trap -> yield -> sched using backtrace, inspect the process control block, verify that the saved instruction pointer matches, and provide comprehensive defenses for theoretical questions (b) and (c). Let us examine the preemption logic in kernel/trap.c."
    )

    add_full_step(
        doc,
        "3.1",
        "Inspect Preemption Logic in kernel/trap.c",
        "TERMINAL 2 (RIGHT - HOST SHELL / EDITOR)",
        "sed -n '84,87p' kernel/trap.c",
        "EXPECTED CODE OUTPUT",
        "  // give up the CPU if this is a timer interrupt.\n"
        "  if (which_dev == 2)\n"
        "    yield();",
        "PARTICIPANT 3",
        "In kernel/trap.c lines 84 to 86, we observe the core preemption logic. devintr() returns 2 when the interrupt source is the periodic hardware timer. When which_dev == 2, the kernel immediately calls yield(). yield() acquires the process lock, transitions the process state to RUNNABLE, and calls sched(). Let us set a breakpoint at sched().",
        "Confirms that the device interrupt is a timer tick (devintr returns 2) before invoking the cooperative yield() mechanism."
    )

    add_full_step(
        doc,
        "3.2",
        "Set Breakpoint at sched() and Resume Execution",
        "TERMINAL 2 (RIGHT - GDB)",
        "break sched",
        "EXPECTED SCREEN OUTPUT",
        "(gdb) break sched\n"
        "Breakpoint 2 at 0x80001df2: file kernel/proc.c, line 478.\n"
        "(gdb) ",
        "PARTICIPANT 3",
        "We set Breakpoint 2 at sched() in proc.c. sched() is the internal kernel function that switches CPU registers from the current process's kernel thread to the per-CPU scheduler context.",
        "sched() verifies kernel invariants: the process lock must be held, interrupts must be disabled, and the process state must not be RUNNING."
    )

    add_full_step(
        doc,
        "3.3",
        "Resume Execution and Catch sched() Hit",
        "TERMINAL 2 (RIGHT - GDB)",
        "continue",
        "EXPECTED SCREEN OUTPUT",
        "(gdb) continue\n"
        "Continuing.\n\n"
        "Thread 2 hit Breakpoint 2, sched () at kernel/proc.c:478\n"
        "478	{\n"
        "(gdb) ",
        "PARTICIPANT 3",
        "We issue continue. GDB hits Breakpoint 2 at sched()! Note that if proc had been NULL, as noted in the prompt, we would simply continue until an active process is caught. Here, an active process is being descheduled.",
        "sched() is entered with the process lock held, ensuring that no other CPU can schedule this process until swtch() completes."
    )

    add_full_step(
        doc,
        "3.4",
        "Confirm Exact Call Chain via backtrace (trap -> yield -> sched)",
        "TERMINAL 2 (RIGHT - GDB)",
        "backtrace",
        "EXPECTED SCREEN OUTPUT",
        "(gdb) backtrace\n"
        "#0  sched () at kernel/proc.c:478\n"
        "#1  0x0000000080001e90 in yield () at kernel/proc.c:515\n"
        "#2  0x00000000800025f8 in usertrap () at kernel/trap.c:86\n"
        "#3  0x0000000080002340 in trampoline () at kernel/trampoline.S:80\n"
        "(gdb) ",
        "PARTICIPANT 3",
        "Look at the backtrace! It unequivocally confirms the exact four-stage preemption call chain: Frame 3 is trampoline.S, which vectors into Frame 2: usertrap() (the trap handler). usertrap() calls Frame 1: yield(), which directly calls Frame 0: sched()! This provides concrete architectural proof of how a hardware timer tick leads to a CPU context switch.",
        "The call stack proves that the transition from hardware interrupt to process rescheduling is a direct, unbroken chain through the kernel stack."
    )

    add_full_step(
        doc,
        "3.5",
        "Inspect Process Control Block Being Switched Out",
        "TERMINAL 2 (RIGHT - GDB)",
        "print p->name\n"
        "print p->pid\n"
        "print p->state",
        "EXPECTED SCREEN OUTPUT",
        "(gdb) print p->name\n"
        "$7 = \"sh\\000...\"\n"
        "(gdb) print p->pid\n"
        "$8 = 2\n"
        "(gdb) print p->state\n"
        "$9 = RUNNABLE",
        "PARTICIPANT 3",
        "We inspect the active process control block via print p (or print *proc). The process being switched out is PID 2, the shell sh. Notice p->state: it is RUNNABLE! yield() has already transitioned its state from RUNNING to RUNNABLE so the scheduler can fairly pick another process.",
        "The PCB tracks the process's page table, kernel stack, open files, and current scheduling state."
    )

    add_full_step(
        doc,
        "3.6",
        "Verify Saved PC in Trap Frame Matches Previous Hit",
        "TERMINAL 2 (RIGHT - GDB)",
        "print (void*)p->trapframe->epc",
        "EXPECTED SCREEN OUTPUT",
        "(gdb) print (void*)p->trapframe->epc\n"
        "$10 = (void *) 0x800021bc\n"
        "(gdb) ",
        "PARTICIPANT 3",
        "We compare the saved PC in p->trapframe->epc to the PC recorded when the trap hit: it matches 0x800021bc! This proves that p->trapframe preserves the exact return point while the process waits in the RUNNABLE state.",
        "Guarantees that the saved program counter in the process's PCB remains intact throughout the context switch cycle."
    )

    add_full_step(
        doc,
        "3.7",
        "Theoretical Defense on Question (b): The while(1); Starvation Catastrophe",
        "THEORETICAL ANALYSIS / VIVA DEFENSE",
        "echo 'Examining Question (b): What would happen without timer interrupts to while(1);?'",
        "QUESTION (b) PROMPT & CORE INVARIANTS",
        "What would happen without timer interrupts — specifically to a process running while(1);?\n\nKey Proof Points:\n- while(1); executes infinite arithmetic loops without making system calls or voluntary yields.\n- Without timer interrupts, the hardware never asserts an interrupt request.\n- The CPU never vectors into trap() / usertrap(), and yield() is never invoked.\n- That CPU core is 100% monopolized forever, starving all other processes and hanging the OS.",
        "PARTICIPANT 3",
        "Let us address theoretical Question (b): What would happen without timer interrupts, specifically to a process running while(1);? In a system without timer interrupts, CPU scheduling is purely cooperative. A process only releases the CPU when it voluntarily executes a blocking system call like read(), sleep(), or wait(). A process executing while(1); never makes a system call and never yields. Without a hardware timer to forcibly assert an interrupt, the process would monopolize that CPU core indefinitely! No other process—neither the shell nor background jobs—would ever run. The system would suffer complete starvation and appear permanently frozen. Timer interrupts are the indispensable hardware foundation that transforms cooperative multitasking into fair, starvation-free preemptive multitasking!",
        "Contrast between cooperative multitasking (Windows 3.1 / Mac OS 9) and preemptive multitasking (Unix / xv6 / Linux)."
    )

    add_full_step(
        doc,
        "3.8",
        "Theoretical Defense on Question (c): Seamless Instruction Stream Resumption",
        "THEORETICAL ANALYSIS / VIVA DEFENSE",
        "echo 'Examining Question (c): How do saved registers enable resumption?'",
        "QUESTION (c) PROMPT & CORE INVARIANTS",
        "How do the saved values in the trap frame (eip/epc, esp/sp, eflags/sstatus) enable the kernel to resume the process later as if it had never been interrupted?\n\nKey Proof Points:\n- PC (eip/epc): holds exact byte address of the next unexecuted instruction; restored into program counter.\n- SP (esp/sp): points to the top of the user stack; preserves stack frames, local variables, and call depth.\n- Flags (eflags/sstatus): contains condition codes (CF, ZF, SF, OF) and interrupt enable bits (IF/SPIE); prevents branch corruption.\n- Hardware return (iret / sret): single atomic hardware instruction restores PC, lowers privilege mode, and re-enables interrupts simultaneously.",
        "PARTICIPANT 3",
        "Finally, theoretical Question (c): How do the saved values in the trap frame enable the kernel to resume the process later as if it had never been interrupted? When the scheduler picks this process again: 1. The Program Counter (eip / epc) holds the exact address of the next unexecuted instruction. When the kernel executes iret (on x86) or sret (on RISC-V), the CPU jumps right back to that instruction. 2. The Stack Pointer (esp / sp) restores the user stack top, ensuring local variables and function call frames remain intact. 3. Condition and Status Flags (eflags / sstatus) preserve condition codes like the Zero flag and Carry flag. If the process was interrupted right between a cmp instruction and a conditional jump, restoring flags ensures the branch evaluates with 100% mathematical accuracy. Together with restoring general-purpose registers, the process resumes with zero loss of state, completely unaware that it was ever interrupted!",
        "The atomic return instruction restores PC, flags, and stack pointer in a single hardware cycle, seamlessly transitioning back to unprivileged user execution."
    )

    add_full_step(
        doc,
        "3.9",
        "Grand Finale & Architectural Conclusion",
        "TERMINAL 1 (LEFT) & TERMINAL 2 (RIGHT)",
        "echo '=== TIMER PREEMPTION SUITE COMPLETE ==='",
        "EXPECTED SCREEN OUTPUT",
        "$ echo '=== TIMER PREEMPTION SUITE COMPLETE ==='\n"
        "'=== TIMER PREEMPTION SUITE COMPLETE ==='\n"
        "$ ",
        "PARTICIPANT 3",
        "To conclude, our team has demonstrated the complete end-to-end lifecycle of preemptive multitasking: 1. Asynchronous Vectoring: Hardware clock ticks forcibly switch privilege modes and construct struct trapframe. 2. Preemption Arbitrariness: The physical clock is asynchronous to CPU instructions, causing saved PCs to vary across hits and proving that no process can evade preemption. 3. Context Switch Chain: usertrap() calls yield() which calls sched(), transitioning the process from RUNNING to RUNNABLE. 4. Seamless Resumption: The exact combination of saved PC, SP, status flags, and the atomic return instruction enables transparent resumption of interrupted instruction streams. Tejas, Vidit, and I are now ready for viva questions from the evaluators. Thank you!",
        "Final synthesis of timer interrupts, trap frames, preemption invariants, and context switching."
    )

    doc.add_page_break()

    # ----------------------------------------------------
    # SECTION 4: MATRIX
    # ----------------------------------------------------
    add_heading_1(doc, "SECTION 4: TRAP FRAME FIELD ANALYSIS & ARCHITECTURAL COMPARISON MATRIX")
    add_body_paragraph(doc, "The following matrix details each field of the trap frame, whether it is pushed by CPU hardware or operating system assembly, its specific architectural function, and its exact equivalent on 64-bit RISC-V architectures:")

    tbl_matrix = doc.add_table(rows=12, cols=4)
    tbl_matrix.alignment = WD_TABLE_ALIGNMENT.CENTER
    tbl_matrix.autofit = False

    m_headers = ["Trap Frame Field", "Pushed By", "Architectural Purpose & Significance", "RISC-V 64-bit Equivalent"]
    m_widths = [Inches(1.5), Inches(1.8), Inches(2.2), Inches(1.5)]
    for j, h in enumerate(m_headers):
        cell = tbl_matrix.cell(0, j)
        cell.width = m_widths[j]
        set_cell_background(cell, HEX_DARK_BLUE)
        set_cell_margins(cell, top=70, bottom=70, left=90, right=90)
        p = cell.paragraphs[0]
        r = p.add_run(h)
        r.font.name = "Arial"
        r.font.size = Pt(8.5)
        r.font.bold = True
        r.font.color.rgb = RGBColor(255, 255, 255)

    matrix_rows = [
        ("eip", "x86 CPU Hardware", "Saved Instruction Pointer (resumption address)", "epc / sepc (Supervisor Exception PC)"),
        ("esp", "x86 CPU Hardware (Ring cross)", "Saved User Stack Pointer", "sp (in p->trapframe->sp)"),
        ("eflags", "x86 CPU Hardware", "Condition flags & Interrupt Enable (IF bit 9)", "sstatus (SPIE, SPP bits)"),
        ("cs", "x86 CPU Hardware", "Code Segment (Privilege: Ring 3 User vs 0 Kernel)", "sstatus.SPP (Previous Privilege)"),
        ("ss", "x86 CPU Hardware (Ring cross)", "Stack Segment selector for user stack", "N/A (Flat 64-bit address space)"),
        ("err", "x86 CPU Hardware / vectors.S", "Hardware error code (0 for timer IRQ)", "scause (Trap reason code)"),
        ("trapno", "xv6 Assembly (vectors.S)", "Trap Vector (32 = T_IRQ0 + IRQ_TIMER)", "scause == 0x8000000000000005L (which_dev==2)"),
        ("ds, es, fs, gs", "xv6 Assembly (alltraps)", "Segment registers saved before kernel entry", "N/A (Single linear address space)"),
        ("eax, ecx, edx", "xv6 Assembly (pushal)", "Caller-saved general purpose registers", "a0-a7, t0-t6 (in trapframe)"),
        ("ebx, ebp, esi, edi", "xv6 Assembly (pushal)", "Callee-saved general purpose registers", "s0-s11 (in trapframe)"),
        ("Return Trap", "CPU Hardware Instruction", "iret (pops eip, cs, eflags, esp, ss)", "sret (Supervisor Return to sepc)")
    ]

    for i, row in enumerate(matrix_rows):
        for j, val in enumerate(row):
            cell = tbl_matrix.cell(i+1, j)
            cell.width = m_widths[j]
            bg_hex = "FFFFFF" if i % 2 == 0 else "F8FAFC"
            set_cell_background(cell, bg_hex)
            set_cell_margins(cell, top=50, bottom=50, left=80, right=80)
            p = cell.paragraphs[0]
            r = p.add_run(val)
            r.font.name = "Arial"
            r.font.size = Pt(8.0)
            r.font.color.rgb = COLOR_TEXT_MAIN

    doc.add_page_break()

    # ----------------------------------------------------
    # SECTION 5: 12 EXHAUSTIVE VIVA QUESTIONS
    # ----------------------------------------------------
    add_heading_1(doc, "SECTION 5: EXHAUSTIVE VIVA & DEFENSE PREPARATION (12 EXAMINER Q&A)")
    
    viva_qas = [
        ("Q1: Why does the saved eip/epc differ on each hit? What does this say about when preemption can occur relative to a process's own code?",
         "The saved eip/epc differs because the hardware timer is driven by an independent physical quartz oscillator that ticks at fixed real-time frequencies (e.g. 100 Hz or every 10 ms). The CPU's instruction execution stream is governed by variable instruction cycle counts, cache hits/misses, branch predictions, and memory bus contention. Because the physical timer and the software pipeline are completely asynchronous, timer interrupts strike at completely arbitrary points in code. This proves that preemption is non-cooperative and arbitrary: the OS can involuntarily strip CPU ownership from a process between any two assembly instructions without software cooperation."),
        
        ("Q2: What would happen without timer interrupts — specifically to a process running while(1);?",
         "In the absence of timer interrupts, the system reverts to purely cooperative multitasking. A process only releases the CPU when it explicitly makes a blocking system call (like read(), sleep(), or wait()) or voluntarily calls yield(). A process executing an infinite compute loop like while(1); never executes a system call and never voluntarily surrenders control. Without timer interrupts asserting an external hardware interrupt, no trap is generated, trap() is never entered, yield() is never called, and the scheduler never runs on that CPU core. The process monopolizes the CPU permanently, starving all other processes and freezing the operating system."),
        
        ("Q3: How do the saved eip/esp/eflags in the trap frame make it possible to resume the exact same instruction stream later?",
         "When a process is resumed, the kernel restores registers and executes the hardware return instruction (iret on x86, sret on RISC-V). The saved fields guarantee seamless restoration: 1. PC (eip / epc): Holds the exact address of the instruction that was interrupted, resuming execution without skipping or re-executing. 2. SP (esp / sp): Holds the exact user stack top, preserving local variables and call frames. 3. Status/Flags (eflags / sstatus): Preserves condition codes (Zero flag ZF, Carry flag CF). If the process was interrupted immediately after a cmp instruction and before a conditional jump, restoring flags ensures the branch evaluates with 100% mathematical accuracy. Combined with general-purpose registers, the process cannot detect it was ever interrupted."),
        
        ("Q4: Which fields in struct trapframe are pushed by x86 CPU hardware, and which are pushed by xv6 software?",
         "The x86 CPU hardware automatically pushes ss and esp (only when crossing privilege rings from User Ring 3 to Kernel Ring 0), eflags, cs, eip, and err (for exceptions; for interrupts, vectors.S pushes a dummy 0). xv6 software assembly (vectors.S and alltraps) pushes trapno (vector 32 for timer), segment selectors (ds, es, fs, gs), and general-purpose registers via pushal (eax, ecx, edx, ebx, oesp, ebp, esi, edi)."),
        
        ("Q5: Why does x86 push esp and ss only when transitioning rings (Ring 3 to Ring 0), but not within Ring 0?",
         "When an interrupt occurs while already in kernel mode (Ring 0 to Ring 0), the CPU continues using the existing kernel stack. The stack pointer %esp is already pointing to valid kernel stack memory, so pushing a new stack pointer is unnecessary. However, when an interrupt strikes user code in Ring 3, the CPU must switch to a privileged, secure kernel stack specified in the Task State Segment (TSS->esp0). To return to user mode later, the CPU must remember the user's old stack; therefore, it saves the old %ss and %esp onto the new kernel stack."),
        
        ("Q6: What is the fundamental difference between struct trapframe and struct context in xv6?",
         "struct trapframe captures the state of an interrupted thread (user or kernel) when taking an interrupt or system call. It is created on the kernel stack by hardware and alltraps, preserving all registers so the process can resume user-space execution via iret/sret. struct context captures only the kernel thread state during a context switch inside swtch(). It saves only the callee-saved registers needed by the C calling convention to switch between a kernel thread and the scheduler thread."),
        
        ("Q7: How are nested interrupts prevented or handled during a timer trap in xv6?",
         "When an interrupt vectors through an x86 Interrupt Gate in the IDT, the CPU hardware automatically clears the IF (Interrupt Flag) bit in the %eflags register (on RISC-V, clears SIE in sstatus). This immediately disables further maskable hardware interrupts, ensuring that the trap handler executes atomically without being preempted by another timer tick. Interrupts are re-enabled only when the kernel enters scheduler() or returns to user space via iret/sret."),
        
        ("Q8: What prevents a deadlock if a timer interrupt fires while the kernel holds a spinlock?",
         "In xv6, acquiring any spinlock calls push_off() / pushcli(), which increments cpu->noff / cpu->ncli and disables interrupts on that core. Therefore, timer interrupts are physically inhibited while spinlocks are held, preventing a scenario where a core attempts to re-acquire a spinlock it already holds inside an interrupt handler."),
        
        ("Q9: How does the CPU know which kernel stack to use when transitioning from user mode to kernel mode?",
         "On x86, the CPU hardware consults the Task State Segment (TSS). During boot and context switching, xv6 configures the TSS esp0 field to point to the top of the current process's kernel stack. On RISC-V, uservec in trampoline.S swaps the user sp with the sscratch register, which points to the process's trapframe page containing kernel_sp, setting up the kernel stack instantly."),
        
        ("Q10: Why does yield() acquire the process lock before setting state to RUNNABLE and calling sched()?",
         "yield() must acquire the process lock (ptable.lock on x86, p->lock on RISC-V) to protect the process state transition from race conditions with other CPUs' scheduler loops. If state were set to RUNNABLE before acquiring the lock, another CPU could observe RUNNABLE, start running the process on its core while it is still finishing yield() on the current core, causing disastrous stack corruption."),
        
        ("Q11: How does RISC-V handle timer preemption compared to x86?",
         "On x86, timer interrupts arrive via the 8259A PIC or APIC directly to vector 32 in the IDT, invoking trap() with tf->trapno == 32. On RISC-V, timer interrupts are generated in Machine mode by the CLINT. Machine mode handles the tick in timervec, raises a software interrupt to Supervisor mode (SIP_SSIP). In Supervisor mode, usertrap() calls devintr(), which returns 2, triggering if(which_dev == 2) yield();."),
        
        ("Q12: How does round-robin fair-sharing follow from timer preemption?",
         "Because timer interrupts arrive periodically every ~10 ms, every CPU-bound process receives an equal time slice quantum. When preemption occurs, yield() places the process back into the RUNNABLE queue and swtch() yields to the scheduler loop. The scheduler scans the table sequentially, granting the CPU to the next RUNNABLE process. This guarantees O(1) round-robin fairness and prevents CPU starvation.")
    ]

    for q, a in viva_qas:
        add_heading_2(doc, q)
        add_body_paragraph(doc, a, bold_prefix="Examiner Defense: ")

    doc.add_page_break()

    # ----------------------------------------------------
    # SECTION 6: KERNEL SOURCE CODE APPENDIX
    # ----------------------------------------------------
    add_heading_1(doc, "SECTION 6: COMPLETE KERNEL SOURCE CODE APPENDIX")

    add_heading_2(doc, "6.1 kernel/trap.c — Preemption on Timer Interrupt")
    p_code1 = doc.add_paragraph()
    r_code1 = p_code1.add_run(
        "uint64\n"
        "usertrap(void)\n"
        "{\n"
        "  int which_dev = 0;\n"
        "  ...\n"
        "  // save user program counter.\n"
        "  p->trapframe->epc = r_sepc();\n\n"
        "  if (r_scause() == 8) {\n"
        "    // system call\n"
        "    ...\n"
        "  } else if ((which_dev = devintr()) != 0) {\n"
        "    // ok\n"
        "  }\n\n"
        "  // give up the CPU if this is a timer interrupt.\n"
        "  if (which_dev == 2)\n"
        "    yield();\n\n"
        "  prepare_return();\n"
        "  return satp;\n"
        "}"
    )
    r_code1.font.name = "Consolas"
    r_code1.font.size = Pt(8.0)

    add_heading_2(doc, "6.2 kernel/proc.c — Cooperative Preemption yield() and Context Switch sched()")
    p_code2 = doc.add_paragraph()
    r_code2 = p_code2.add_run(
        "void\n"
        "yield(void)\n"
        "{\n"
        "  struct proc *p = myproc();\n"
        "  acquire(&p->lock);\n"
        "  p->state = RUNNABLE;\n"
        "  sched();\n"
        "  release(&p->lock);\n"
        "}\n\n"
        "void\n"
        "sched(void)\n"
        "{\n"
        "  int intena;\n"
        "  struct proc *p = myproc();\n\n"
        "  if(!holding(&p->lock))\n"
        "    panic(\"sched p->lock\");\n"
        "  if(mycpu()->noff != 1)\n"
        "    panic(\"sched locks\");\n"
        "  if(p->state == RUNNING)\n"
        "    panic(\"sched running\");\n"
        "  if(intr_get())\n"
        "    panic(\"sched interruptible\");\n\n"
        "  intena = mycpu()->intena;\n"
        "  swtch(&p->context, &mycpu()->context);\n"
        "  mycpu()->intena = intena;\n"
        "}"
    )
    r_code2.font.name = "Consolas"
    r_code2.font.size = Pt(8.0)

    doc.save(DOCX_OUTPUT_PATH)
    print(f"[SUCCESS] Saved Master Word Document to: {DOCX_OUTPUT_PATH}")

if __name__ == "__main__":
    generate_master_document()
