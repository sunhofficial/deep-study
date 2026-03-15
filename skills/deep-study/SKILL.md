---
name: deep-study
description: "Deep-dive research skill for understanding how code works under the hood. Analyzes project code + collects external resources + generates NotebookLM artifacts + saves multi-note Obsidian output. Trigger when: user wants to deeply understand a concept they encountered in code, asks about internal mechanics or architecture of a technology, says 'how does X work', 'deep dive into X', 'study X', 'I want to understand X deeply', or encounters unfamiliar code patterns and wants to learn the underlying principles."
---

# Deep Study — All-in-One Deep Research Skill

Systematically study any topic: analyze project code, collect external resources, generate NotebookLM artifacts (text + visual), and save multi-note Obsidian output — all in one run.

## Workflow

```
User: "{topic} 공부하고 싶어"
  ↓
Phase 1: Code analysis — how the topic is used in the current project
Phase 2: Resource collection — blogs, YouTube, official docs, open-source refs
Phase 3: NotebookLM — study-guide + quiz + flashcards + infographic + mind-map
Phase 4: Obsidian — multi-note output with wikilinks + visual assets → auto-open MOC
```

## Bash Permission Notice

This skill runs many Bash commands (NotebookLM CLI, etc). Inform the user once at the start:

> This skill runs Bash commands frequently. For uninterrupted execution, run this once:
> ```
> claude config set --project allowedTools "Bash(*)"
> ```
> Skip if already configured.

Proceed immediately after the notice. Do not wait for confirmation.

## Phase 0: Setup (first run only)

### 0-1. Learner Profile

Config file: `~/.config/deep-study/config.json`

**If file does not exist**, use **AskUserQuestion** tool to ask all 3 settings with interactive selection UI (arrow keys + Enter).

**MANDATORY**: Use AskUserQuestion with 3 questions in a single call:

```
Question 1:
  question: "경험 수준을 선택하세요"
  header: "Level"
  options:
    - label: "junior", description: "취준생/신입 (<1년). 기초부터, 면접 대비 집중"
    - label: "mid", description: "주니어~미들 (1-4년). 실무 패턴, 왜 이렇게 동작하는지"
    - label: "senior", description: "시니어 (5년+). 내부 구현/아키텍처/트레이드오프, 기초 생략"

Question 2:
  question: "플랫폼을 선택하세요"
  header: "Platform"
  options:
    - label: "ios", description: "iOS (UIKit, SwiftUI)"
    - label: "android", description: "Android (Jetpack, Compose)"
    - label: "web-frontend", description: "Web Frontend (React, Vue 등)"
    - label: "web-backend", description: "Web Backend (Node, Django 등)"

Question 3:
  question: "코드 예시에 사용할 언어를 선택하세요"
  header: "Language"
  options:
    - label: "swift", description: "iOS / macOS"
    - label: "kotlin", description: "Android / JVM"
    - label: "typescript", description: "Web / Node.js"
    - label: "python", description: "Backend / ML / Scripts"
```

> Note: AskUserQuestion supports max 4 options per question. For Platform, the 4 most common options are listed; less common ones (fullstack, devops, data, general) are available via "Other". Same for Language (go, java, rust available via "Other").

Parse the responses and save all 3 values:

```bash
mkdir -p ~/.config/deep-study
cat > ~/.config/deep-study/config.json << 'EOF'
{
  "level": "mid",
  "platform": "ios",
  "language": "swift"
}
EOF
```

**If file already exists**, read it and skip. Do not ask again.

### Platform Effects

| Area | Effect |
|------|--------|
| Phase 1 code search | File patterns matching platform (`.swift`, `.kt`, `.tsx`, etc.) |
| Phase 2 search keywords | "topic + WWDC" vs "topic + Google I/O" vs "topic + React Conf" |
| Concept notes | Platform-contextualized explanations (e.g., memory → ARC vs GC) |
| Open-source refs | Prioritize famous projects in the platform ecosystem |
| Interview questions | Platform-specific frequently asked questions |

### Level Effects

| Area | junior | mid | senior |
|------|--------|-----|--------|
| **Prerequisites** | Detailed + links | Keywords + 1-line | Omit (assumed known) |
| **Difficulty split** | 70% essential, few advanced | Balanced | 50%+ advanced |
| **Note depth** | Step-by-step from basics | "Why" + practical patterns | Internal impl / source level |
| **Code examples** | Heavy comments, step-by-step | Production-ready code | Minimal code + key points only |
| **Troubleshooting** | Common mistakes + basic debug | Frequently hit issues | Edge cases + perf/memory |
| **Quiz difficulty** | Heavy recall, basic interview | Balanced | Heavy analysis/interview |
| **Interview Qs** | "Explain X" basics | "Why X?" + follow-ups | "Design X" + tradeoffs |
| **Open-source refs** | Usage-focused links | Implementation patterns | Source code analysis |

### 0-2. NotebookLM Auth

Check if notebooklm CLI is installed and authenticated:

```bash
export PATH="$HOME/.local/bin:$PATH"
if command -v notebooklm &>/dev/null; then
  notebooklm auth check --json 2>&1
else
  echo '{"installed": false}'
fi
```

- If not installed → tell user: `pip install notebooklm` or `pipx install "notebooklm-py[browser]"`
- If installed + auth OK (`"token_fetch": true`) → proceed to Phase 1
- If installed + auth needed → tell user:

> NotebookLM auth required. Run in terminal:
> ```
> notebooklm login
> ```
> Complete Google login in browser, then say "done".

After auth, proceed. Subsequent sessions: skip setup (`notebooklm auth check --json` for quick check).

## Phase 1: Project Code Analysis

Only run if CWD is a code project. Skip otherwise.

1. **Grep/Glob for topic-related code**
   - Match filenames, class names, imports, function names
   - e.g., "WebView" → `WebView.swift`, `WKWebView`, `UIViewRepresentable`

2. **Read key files**
   - Understand implementation, patterns, config, init, data flow, error handling

3. **Write code analysis summary** (included in Phase 4 Obsidian notes)
   - Usage patterns in our project
   - Strengths / areas for improvement
   - Identify areas needing deeper study

## Phase 2: External Resource Collection

Use WebSearch to collect learning resources.

1. **Official docs** — Apple Developer Docs, MDN, official guides (top priority)

2. **Blogs/articles** — "topic + best practices", "topic + tutorial", "topic + deep dive" (Korean + English)

3. **YouTube** — "topic + WWDC/Google I/O/conf", "topic + tutorial", "topic + explained"

4. **Open-source references** — "topic + github", "topic + best implementation github"
   - Find 1-2 well-implemented open-source projects
   - Link to specific files/modules, not repo root

5. **Quality filter**
   - Prefer resources from last 2 years
   - Official docs > popular blogs > general posts
   - Collect 8-15 URLs (extra buffer for NotebookLM source failures)

Proceed to Phase 3 automatically. No confirmation needed.

## Phase 3: NotebookLM Integration

Use `notebooklm` CLI. Prepend `export PATH="$HOME/.local/bin:$PATH"` to all commands.

### 3-1. Create Notebook + Add Sources (single Bash call)

Minimize Bash calls by combining notebook creation → context → code analysis file → source addition:

```bash
export PATH="$HOME/.local/bin:$PATH"

# Save code analysis to file
cat > /tmp/deep-study-code-analysis.md << 'EOF'
{Phase 1 code analysis summary markdown}
EOF

# Create notebook + set context
NOTEBOOK_ID=$(notebooklm create "Deep Study: {topic}" --json 2>&1 | python3 -c "import sys,json; print(json.load(sys.stdin)['notebook']['id'])")
notebooklm use "$NOTEBOOK_ID"

# Add sources (URLs + code analysis file)
notebooklm source add "{url1}" --json 2>&1
notebooklm source add "{url2}" --json 2>&1
# ... all URLs
notebooklm source add /tmp/deep-study-code-analysis.md --json 2>&1

# Check source status
notebooklm source list --json 2>&1
```

### 3-1b. Auto-Replace Failed Sources

If any source has `"status": "error"`:
1. Count failed sources
2. WebSearch for replacement URLs (same count as failures)
3. Add replacements via single Bash call
4. Ensure **minimum 6 ready sources**

Auto-retry. If replacement search also fails, proceed with current sources.

### 3-2. Generate Content (text + visual artifacts)

Generate all artifacts. Single Bash call:

```bash
export PATH="$HOME/.local/bin:$PATH"

# Text artifacts
notebooklm generate report --format study-guide --language ko 2>&1
notebooklm generate quiz --difficulty medium 2>&1
notebooklm generate flashcards 2>&1

# Visual artifacts
notebooklm generate infographic "핵심 개념과 구조를 시각적으로 정리" --style professional --language ko --detail detailed --wait 2>&1
notebooklm generate mind-map 2>&1
```

> Note: `--language` flag only works on `report` and `infographic`, not quiz/flashcards.

While waiting: start drafting Phase 4 Obsidian notes (Write tool, no Bash needed). Add generated content when ready.

### 3-3. Download (single Bash call)

```bash
export PATH="$HOME/.local/bin:$PATH"

# Remove stale files to avoid download conflicts
rm -f /tmp/deep-study-report.md /tmp/deep-study-quiz.md /tmp/deep-study-flashcards.md
rm -f /tmp/deep-study-infographic.png /tmp/deep-study-mindmap.json

# Text artifacts
notebooklm download report /tmp/deep-study-report.md 2>&1
notebooklm download quiz /tmp/deep-study-quiz.md --format markdown 2>&1
notebooklm download flashcards /tmp/deep-study-flashcards.md --format markdown 2>&1

# Visual artifacts
notebooklm download infographic /tmp/deep-study-infographic.png 2>&1
notebooklm download mind-map /tmp/deep-study-mindmap.json 2>&1
```

Skip failed downloads. Include only successful ones in Obsidian notes.

### 3-4. Visual Asset Processing

After downloading visual artifacts:

1. **Infographic (PNG)**: Copy to `Deep Study/{topic}/assets/infographic.png`
   - Embed in MOC: `![[assets/infographic.png]]`

2. **Mind Map (JSON)**: Convert to Mermaid diagram for Obsidian embedding
   - Parse the JSON structure
   - Generate a `mindmap` Mermaid code block
   - Embed in MOC inside a fenced code block: ````mermaid\nmindmap\n  root(({topic}))\n    ...\n````

## Phase 4: Obsidian Multi-Note Output

Vault path: Detect automatically. Check `~/.config/deep-study/config.json` for `obsidianVault`. If not set, search common locations:
1. `~/Documents/Obsidian Vault/`
2. `~/Obsidian/`
3. Ask user on first run and save to config.json as `"obsidianVault": "/path/to/vault"`

Output path: `{vault}/Deep Study/{topic}/`

### Output Structure

```
Deep Study/{topic}/
  assets/
    infographic.png              # NotebookLM infographic
  00-MOC.md                      # Learning map + checklist + resources + visual overview
  01-{concern1}.md               # e.g., Multi-process Architecture
  02-{concern2}.md               # e.g., Lifecycle & Configuration
  ...
  NN-우리 프로젝트 분석.md          # Phase 1 code analysis results
  Practice.md                    # Collapsible quiz (all notes combined)
```

### Note Splitting Principles

- **Split criteria**: "A unit you'd Google in a real work scenario"
- **1 note = 1 concern**: cookie management, JS bridge, memory kill handling, etc.
- **Note count**: Flexible per topic (typically 8-12)
- **Each note must be independently readable** (understandable without context)

### Writing Principles — What "Deep" Means

Surface-level API listing is NOT Deep Study. Each concept note must provide **developer-level depth**: the kind of understanding you'd get from reading the framework source code, WWDC sessions, and production post-mortems combined.

**Depth requirements for every concept note:**

1. **Internal mechanics (필수)**
   - Not "what API to call" but HOW it works internally
   - Process/thread model, memory layout, data flow between components
   - What happens step-by-step when you call an API (e.g., `webView.load()` → URL loading pipeline → network process IPC → WebContent render → compositing → display)

2. **Design rationale (필수)**
   - WHY Apple/Google/framework authors designed it this way
   - What tradeoffs they made and what alternatives they rejected
   - Historical context: what problem existed before, how this solution evolved

3. **Architecture diagrams (필수)**
   - Every note MUST have at least one Mermaid diagram or ASCII diagram
   - Process flows, state machines, class relationships, data flow
   - Use Mermaid (Obsidian native support) for complex diagrams:
     ```mermaid
     graph LR
       A[App Process] -->|IPC| B[WebContent Process]
       B -->|IPC| C[Network Process]
     ```
   - Use ASCII art for simple inline diagrams

4. **Real-world troubleshooting (필수)**
   - Not hypothetical problems — actual production issues developers hit
   - Root cause analysis: why does this happen at the system level
   - Debug methodology: how to diagnose, what tools to use, what logs to check

5. **Comparative analysis (해당 시)**
   - When alternatives exist: detailed comparison with concrete criteria
   - Not just a feature table — when to pick which and WHY
   - Performance characteristics, memory footprint, API ergonomics

6. **Performance & Memory deep dive (해당 시)**
   - Memory ownership model, retain cycles, leak patterns
   - CPU/GPU implications, main thread vs background
   - Profiling tips: Instruments templates, what to measure

7. **Security implications (해당 시)**
   - Attack surface, common vulnerabilities
   - Defensive patterns, framework-provided mitigations

8. **Source-level insights (senior level)**
   - Reference WebKit/framework source code when explaining internals
   - Link to specific source files in open-source implementations
   - "If you read the source, you'd see that..."

**Minimum depth per section:**
- `## 상세 설명`: At least 3 sub-sections (###), each 3-5 paragraphs. Include at least 1 diagram.
- `## 실전 코드`: At least 2 code examples — one basic, one production-grade with error handling
- `## 트러블슈팅`: At least 2 real-world problems with full root-cause analysis

**Anti-patterns (DO NOT do these):**
- ❌ "WKWebView는 멀티프로세스로 동작합니다." (too shallow — explain the IPC mechanism, Mach ports, XPC)
- ❌ One-liner bullet points without explanation
- ❌ API docs copy-paste without analysis
- ❌ Code without surrounding context explaining what it solves and why

**Good depth example:**
- ✅ "WKWebView는 XPC(Cross-Process Communication)를 통해 App Process와 WebContent Process가 통신한다. 구체적으로, WKWebView 객체는 App Process의 UIProcess 레이어에 존재하고, 실제 DOM 파싱과 JavaScript 실행은 별도의 WebContent Process에서 수행된다. 이 두 프로세스 간 통신은 Mach 포트 기반의 IPC로 이루어지며, 이것이 WKWebView가 UIWebView보다 느린 초기화 시간을 갖는 근본 원인이다..."

Synthesize Phase 1 (code analysis) + Phase 2 (external resources) + Phase 3 (NotebookLM report) into the structures below.

### Study-Guide Distribution Strategy

Do NOT dump the entire study-guide into MOC. Distribute into each concept note's `## 상세 설명`:
- Each study-guide section/topic → assign to the most relevant concept note
- Cross-cutting content → put in the most central note, reference others via `[[wikilink]]`
- MOC's NotebookLM section → **3-line summary only**

### 4-1. MOC (00-MOC.md)

All notes are written in **Korean**. Below is the template:

```markdown
---
tags: [deep-study, {topic}]
date: {date}
sources: {URL count}
notebooklm_id: {id}
---

# {topic} Deep Study

## 전체 구조 한눈에 보기

> [!info] Infographic
> ![[assets/infographic.png]]

```mermaid
mindmap
  root(({topic}))
    {branch1}
      {leaf1}
      {leaf2}
    {branch2}
      {leaf3}
    ...
```

## 선수 지식
> [!warning] 이 주제를 공부하기 전에
> - **{Concept A}**: {1-line} — [[Deep Study/{related}/00-MOC|이미 공부함]] or 미학습
> - **{Concept B}**: {1-line}
> - **{Concept C}**: {1-line}
>
> 선수 지식이 부족하면 해당 주제를 먼저 `/deep-study`로 공부하는 것을 권장.

## 학습 맵
| # | 주제 | 핵심 | 난이도 | 상태 |
|---|------|------|--------|------|
| 01 | [[01-{title}]] | {1-line} | 필수 | [ ] |
| 02 | [[02-{title}]] | {1-line} | 필수 | [ ] |
| ... | ... | ... | 권장/심화 | ... |

> 난이도 기준: **필수** = must-know to use this topic / **권장** = good to know, avoids pain / **심화** = deep interview or internal curiosity
> Split ratio follows config.json level (junior: 70% 필수 / mid: balanced / senior: 50%+ 심화)

| NN | [[NN-우리 프로젝트 분석]] | 현재 코드베이스 분석 | 필수 | [ ] |
| - | [[Practice]] | 퀴즈 & 복습 | - | [ ] |

> [!tip] 학습 순서 가이드
> **처음이면**: 우리 프로젝트 분석 훑기 → 필수 노트 순서대로 → Practice → 권장 → 심화
> **복습이면**: Practice 먼저 풀고 → 틀린 문제의 [[관련 노트]] 다시 읽기

## 학습 자료
### 공식 문서
- [Title](URL)
### 블로그 & 아티클
- [Title](URL) — 1-line summary
### YouTube / WWDC
- [Title](URL) — 1-line summary

## NotebookLM
> [!info] NotebookLM Study Guide
> {3-line summary only. Detailed content distributed to concept notes.}

## 관련 Deep Study
> 이 주제와 연결되는 다른 학습 노트:
- [[Deep Study/{related1}/00-MOC]] — connection reason
- [[Deep Study/{related2}/00-MOC]] — connection reason

> 아직 Deep Study하지 않은 관련 주제:
- {Topic X} — why related
- {Topic Y} — why related

## 추가 학습 포인트
- [ ] Further topic 1
- [ ] Further topic 2
```

### 4-2. Concept Notes (01~NN)

```markdown
---
tags: [deep-study, {topic}, {subtag}]
keywords: [3-5 English keywords]
---

# {Note Title}

## 핵심 요약
> 3-line max core summary (readable standalone)

## 상세 설명

### {Sub-topic 1: 동작 원리 / 내부 구조}

{3-5 paragraphs explaining internal mechanics. Not "how to use" but "how it works".
Include WHY it was designed this way. Reference framework source code or WWDC sessions.
Explain the step-by-step flow of what happens internally.}

```mermaid
{Mermaid diagram showing the architecture, flow, or state machine}
```

### {Sub-topic 2: 설계 배경 / 역사적 맥락}

{Why does this exist? What problem did it solve? What was the previous approach?
What tradeoffs did the designers make? What alternatives were considered?}

### {Sub-topic 3: 심화 — 엣지케이스, 성능, 메모리}

{Deep dive into edge cases, performance characteristics, memory implications.
What happens under memory pressure? What about concurrency?
Profiling tips, Instruments templates, debugging approaches.}

## 실전 코드

### 기본 사용
```{language from config}
// Basic usage with comments explaining the "why" behind each line
```

### 프로덕션 레벨
```{language from config}
// Production-grade code with proper error handling,
// edge case coverage, and defensive patterns.
// This should be copy-pasteable into a real project.
```

## 트러블슈팅

### 문제 1: {symptom}
- **증상**: What the developer sees (error message, visual bug, crash log)
- **근본 원인**: System-level explanation of WHY this happens
- **진단 방법**: How to diagnose (Instruments, lldb, print debugging, etc.)
- **해결**: Code fix with explanation
- **예방**: Architectural pattern to prevent recurrence

### 문제 2: {symptom}
- **증상**: ...
- **근본 원인**: ...
- **진단 방법**: ...
- **해결**: ...
- **예방**: ...

## 오픈소스 레퍼런스 (optional)
- [Project - file/module](GitHub URL) — why this is worth referencing, what you can learn from their approach

> Distribute 2-3 across the whole topic to relevant notes only. Do NOT force into every note.
> If no good open-source reference exists for this note's topic, omit this section.

## Related
- [[related note 1]]
- [[related note 2]]
- [[Practice]] — Q{number}
```

### 4-3. Project Analysis Note (NN-우리 프로젝트 분석.md)

Only generated when Phase 1 found project code. Phase 1 code analysis as independent note:

```markdown
---
tags: [deep-study, {topic}, project-analysis]
keywords: [project-related keywords]
---

# 우리 프로젝트 분석

## 핵심 요약
> 3-line summary of how this topic is used in our project

## 사용 패턴

### 패턴 1: {pattern name}
```{language}
// Actual code from our project (simplified if needed)
```
- 장점: ...
- 개선 가능: ...

### 패턴 2: {pattern name}
```{language}
// Actual code from our project
```

## 관련 파일
| 파일 | 역할 |
|------|------|
| `path/file.ext` | description |

## 개선 포인트

### 1. {issue} (우선순위: 높음/중간/낮음)
현재 코드:
```{language}
// current problematic code
```
개선안:
```{language}
// improved code with explanation
```

## Related
- [[related concept note 1]]
- [[related concept note 2]]
```

### 4-4. Practice.md (Collapsible Quiz)

Combines NotebookLM quiz/flashcards + custom questions. Answers hidden by default:

```markdown
---
tags: [deep-study, {topic}, practice]
---

# {topic} Practice

## Q1 - {short label} [recall]
> 1-line scenario

> [!answer]- 정답 보기
> Answer + explanation + [[related note]] link

---

## Q2 - {short label} [application]
> How would you solve this situation?

> [!answer]- 정답 보기
> Application-type answer

---

## Q3 - {short label} [analysis]
> Compare A and B. When to use which?

> [!answer]- 정답 보기
> Comparative analysis answer

---

## Q4 - {short label} [interview]
> 면접관: "{frequently asked interview question}"

> [!answer]- 모범 답변
> **핵심 포인트** (what the interviewer wants to hear):
> 1. ...
> 2. ...
> 3. ...
>
> **답변 예시**:
> "..." (speakable form)
>
> **꼬리 질문 대비**:
> - Q: ...? → A: ...
> - Q: ...? → A: ...
>
> [[related note]]
```

- Collapsible answers: `> [!answer]- 정답 보기` (collapsed in Obsidian)
- Question types: `[recall]` / `[application]` / `[analysis]` / `[interview]`
- `[interview]` = based on frequently asked interview Qs, includes follow-up prep
- Each question links to `[[related note]]`
- NotebookLM quiz/flashcards content converted to this format

**Question count guide (12-18 total):**

| Type | Count | Purpose |
|------|-------|---------|
| `[recall]` | 3-5 | Core concept recall |
| `[application]` | 3-5 | Apply to real scenarios |
| `[analysis]` | 2-3 | Compare / tradeoff analysis |
| `[interview]` | 3-5 | Technical interview prep |

- Never exceed 30 questions. People won't complete them.
- If NotebookLM generates too many, curate by quality to fit the range above.

### Wikilink Rules

- All concept notes have `## Related` section at bottom
- MOC links to all notes via `[[wikilink]]` (by filename)
- Practice links to related notes via `[[wikilink]]`
- Bidirectional cross-references between notes

### Phase 4 Execution Flow

1. Analyze topic → determine note list by practical concern units (8-12) + classify difficulty (필수/권장/심화)
2. Prerequisites analysis → what must be known before this topic
3. Scan existing Deep Studies → Glob `Deep Study/` folder for existing topics → decide cross-study links
4. Create `Deep Study/{topic}/` folder + `assets/` subfolder
5. Copy infographic PNG to `assets/` folder
6. Convert mind-map JSON to Mermaid diagram for MOC
7. Generate 00-MOC.md (infographic embed + mind-map Mermaid + prerequisites + learning map + resources + NotebookLM summary + cross-study links)
8. Generate concept notes sequentially (01~ via Write tool, with diagrams + deep explanations + open-source refs)
9. Generate NN-Project Analysis.md (Phase 1 results)
10. Generate Practice.md (NotebookLM quiz/flashcards + custom questions + `[interview]` type)
11. Auto-open MOC in Obsidian

### Auto-Open MOC

Use the vault name from config.json `obsidianVault` path (extract last path component, URL-encode spaces):

```bash
# Example: if obsidianVault is "~/Documents/Obsidian Vault", vault name = "Obsidian Vault"
VAULT_NAME=$(basename "{obsidianVault path}" | sed 's/ /%20/g')
open "obsidian://open?vault=${VAULT_NAME}&file=Deep%20Study%2F{URL-encoded topic}%2F00-MOC"
```

## Execution Principles

The entire workflow runs **fully automatically without user confirmation**:
- Phase 1 → 2 → 3 → 4 sequential execution
- Resources: 8-15 URLs auto-collected, auto-replacement on failure
- Content: study-guide + quiz + flashcards + infographic + mind-map (all by default)
- Further study points: auto-suggested and included in notes
- Do NOT stop to ask the user. Run to completion.

## Caveats

- **NotebookLM daily limit** — free tier has generation limits; don't spam requests
- **Source processing time** — URLs may take 30s-10min to become ready after adding
- **Source failures are common** — Medium, some blogs can't be crawled by NotebookLM. Auto-replacement handles this
- **Unofficial API** — notebooklm-py is unofficial; may break if Google changes their API
- **Code analysis is optional** — skip Phase 1 if CWD is not a project directory
- **Korean-first output** — Notes and generated content in Korean; searches in both Korean + English
- **Visual artifact failures** — infographic/mind-map generation may fail; proceed without them if so
