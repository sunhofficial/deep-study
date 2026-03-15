<p align="center">
  <img src="assets/banner.png" alt="Deep Study — From Single Command to Expert Knowledge Base" width="800">
</p>

<h1 align="center">Deep Study</h1>

<p align="center">
  <strong>One command. 10+ interconnected notes. From zero to deep understanding.</strong>
</p>

<p align="center">
  <a href="#install">Install</a> •
  <a href="#how-it-works">How It Works</a> •
  <a href="#features">Features</a> •
  <a href="#examples">Examples</a> •
  <a href="#한국어">한국어</a>
</p>

---

You encounter unfamiliar code at work. You Google. Open 15 tabs. Skim. Forget everything by Friday.

**Deep Study** compresses that entire cycle into a single command — and outputs structured Obsidian notes you'll actually revisit.

```
/deep-study WKWebView
```

That's it. Go grab coffee. Come back to **10+ deep-dive notes** with architecture diagrams, production code, troubleshooting guides, and a quiz — all wikilinked and ready in Obsidian.

---

## Install

```bash
claude plugin add sunhofficial/deep-study
```

<details>
<summary>Alternative: install as standalone skill</summary>

```bash
git clone https://github.com/sunho/deep-study.git
claude skill add ./deep-study/skills/deep-study
```

</details>

First run walks you through setup (experience level, platform, NotebookLM auth). Takes ~2 minutes once.

---

## How It Works

```
/deep-study {topic}
       │
       ▼
  ┌─────────────┐    ┌──────────────┐    ┌──────────────┐    ┌────────────────┐
  │  Phase 1    │    │   Phase 2    │    │   Phase 3    │    │    Phase 4     │
  │ Code Scan   │───▶│  Web Search  │───▶│  NotebookLM  │───▶│ Obsidian Notes │
  │             │    │              │    │              │    │                │
  │ Your project│    │ 8-15 URLs    │    │ Study guide  │    │ 10+ notes      │
  │ grep/read   │    │ Docs, blogs  │    │ Quiz         │    │ Wikilinks      │
  │ patterns    │    │ YouTube      │    │ Flashcards   │    │ Diagrams       │
  │             │    │ Open-source  │    │ Infographic  │    │ Practice quiz  │
  └─────────────┘    └──────────────┘    └──────────────┘    └────────────────┘
                                                                     │
                                                                     ▼
                                                              Auto-opens in
                                                                Obsidian
```

**Fully automatic.** No confirmations between phases. Start it and walk away.

---

## What You Get

```
Deep Study/WKWebView/
  assets/infographic.png              ← NotebookLM visual overview
  00-MOC.md                           ← Learning map + mind-map + resources
  01-멀티프로세스 아키텍처.md           ← How IPC works via Mach ports
  02-WKWebViewConfiguration과 생명주기.md
  03-SwiftUI 통합 (UIViewRepresentable).md
  04-JavaScript 브릿지.md
  05-WKContentWorld와 스크립트 격리.md
  06-Navigation과 로딩 제어.md
  07-쿠키와 세션 관리.md
  08-프로세스 종료와 빈 화면 복구.md
  09-보안 (App-bound Domains, ITP).md
  10-성능 최적화와 예열.md
  11-우리 프로젝트 분석.md              ← Your codebase: what's good, what to fix
  Practice.md                          ← 15 collapsible quiz questions
```

### Not your typical study notes

Every concept note goes **deep**:

| Section | What's Inside |
|---------|---------------|
| **핵심 요약** | 3-line TL;DR — readable standalone |
| **상세 설명** | Internal mechanics + design rationale + Mermaid diagrams |
| **실전 코드** | Basic usage → production-grade (copy-pasteable) |
| **트러블슈팅** | Real-world bugs with root-cause analysis |
| **Related** | `[[wikilinks]]` to connected notes |

---

## Before vs After

| | Without Deep Study | With Deep Study |
|---|---|---|
| **Time** | 2-3 hours googling + reading | ~15 min (automated) |
| **Output** | 15 browser tabs, nothing saved | 10+ structured Obsidian notes |
| **Depth** | Surface-level blog skimming | Internal mechanics + source-level |
| **Your code** | Not analyzed | Patterns identified + improvements suggested |
| **Retention** | Forget by Friday | Quiz + wikilinked notes to revisit |
| **Diagrams** | None | Mermaid in every note |

---

## Features

- **Adaptive depth** — Junior gets step-by-step basics; senior gets framework internals and tradeoffs
- **Platform-aware** — iOS (WWDC, ARC, Swift) / Android (I/O, GC, Kotlin) / Web (MDN, V8, TypeScript)
- **NotebookLM integration** — Study guide + quiz + flashcards + infographic + mind-map
- **Project analysis** — Scans your actual codebase, finds patterns and improvement points
- **Obsidian-native** — Wikilinks, collapsible callouts, Mermaid diagrams, graph view ready
- **Practice quiz** — 12-18 questions: `[recall]` `[application]` `[analysis]` `[interview]`
- **Auto-replacement** — Failed NotebookLM sources are automatically replaced with new URLs
- **One command** — Runs Phase 1→2→3→4 without stopping for confirmation

---

## Examples

```bash
# iOS
/deep-study WKWebView
/deep-study Swift Concurrency
/deep-study Core Data

# Android
/deep-study Jetpack Compose
/deep-study Coroutines
/deep-study Room Database

# Web
/deep-study React Server Components
/deep-study WebSocket
/deep-study Service Workers
```

---

## Adapts to You

On first run, you pick your profile:

| Setting | Options |
|---------|---------|
| **Level** | `junior` · `mid` · `senior` |
| **Platform** | `ios` · `android` · `web-frontend` · `web-backend` |
| **Language** | `swift` · `kotlin` · `typescript` · `python` |

<details>
<summary><strong>How level affects output</strong></summary>

| | junior | mid | senior |
|---|--------|-----|--------|
| **Prerequisites** | Detailed + links | Keywords + 1-line | Omitted |
| **Difficulty** | 70% essential | Balanced | 50%+ advanced |
| **Note depth** | Step-by-step | "Why" + patterns | Internals / source-level |
| **Code** | Heavy comments | Production-ready | Minimal + key points |
| **Quiz** | Recall-heavy | Balanced | Analysis/interview-heavy |

</details>

Config saved to `~/.config/deep-study/config.json`. Change anytime.

---

## Prerequisites

| Tool | Required | Install |
|------|----------|---------|
| [Claude Code](https://docs.anthropic.com/en/docs/claude-code) | Yes | `npm install -g @anthropic-ai/claude-code` |
| [Obsidian](https://obsidian.md/) | Yes | Download from site |
| [notebooklm-py](https://github.com/nicholasgasior/notebooklm-py) | Yes | `pipx install "notebooklm-py[browser]"` |

<details>
<summary><strong>NotebookLM auth setup</strong></summary>

After installing notebooklm-py, authenticate with Google:

```bash
notebooklm login
```

Complete the Google login in your browser. This is a one-time step.

The skill auto-checks auth on every run and will prompt you if it expires.

</details>

<details>
<summary><strong>Recommended: allow Bash for uninterrupted runs</strong></summary>

Deep Study runs many Bash commands (NotebookLM CLI, file operations). To avoid permission prompts:

```bash
claude config set --project allowedTools "Bash(*)"
```

</details>

---

## Caveats

- **NotebookLM** uses an [unofficial API](https://github.com/nicholasgasior/notebooklm-py). Free tier has daily generation limits.
- **Source failures** are common (Medium, paywalled sites). The skill auto-replaces them.
- **Visual artifacts** (infographic, mind-map) may occasionally fail. The skill proceeds without them.
- **Notes are in Korean** by default. Searches run in both Korean and English.

---

## License

MIT

---

<h2 id="한국어">한국어 가이드</h2>

### 이게 뭔가요?

**Deep Study**는 Claude Code용 올인원 딥러닝(공부) 스킬입니다.

공부하고 싶은 주제를 말하면:
1. 현재 프로젝트에서 관련 코드를 분석하고
2. 웹에서 8-15개 학습 자료를 자동 수집하고
3. NotebookLM으로 학습 가이드 + 퀴즈 + 인포그래픽을 생성하고
4. Obsidian에 10개 이상의 연결된 노트를 작성합니다

### 사용법

```
/deep-study WKWebView
```

이 한 줄이면 끝입니다. 커피 한 잔 마시고 오면 Obsidian에 학습 노트가 준비되어 있습니다.

### 설치

```bash
claude plugin add sunhofficial/deep-study
```

### 첫 실행 시 설정

| 설정 | 선택지 |
|------|--------|
| **경험 수준** | `junior` (취준생/신입) · `mid` (1-4년) · `senior` (5년+) |
| **플랫폼** | `ios` · `android` · `web-frontend` · `web-backend` |
| **언어** | `swift` · `kotlin` · `typescript` · `python` |

설정은 `~/.config/deep-study/config.json`에 저장되며, 다시 묻지 않습니다.

### 출력 예시

```
Deep Study/WKWebView/
  00-MOC.md              ← 학습 맵 + 자료 링크 + 마인드맵
  01~10-개념노트.md       ← 내부 동작 원리 + Mermaid 다이어그램 + 실전 코드
  11-우리 프로젝트 분석.md ← 우리 코드 분석 + 개선 포인트
  Practice.md            ← 접이식 퀴즈 15문제 (정답 숨김)
```

### 필요한 도구

- **Claude Code** — `npm install -g @anthropic-ai/claude-code`
- **Obsidian** — [obsidian.md](https://obsidian.md/)
- **notebooklm-py** — `pipx install "notebooklm-py[browser]"` 설치 후 `notebooklm login`

### 주의사항

- NotebookLM은 비공식 API를 사용합니다 (무료 일일 한도 있음)
- 일부 URL은 NotebookLM에서 크롤링 실패할 수 있습니다 (자동 대체됨)
- 노트는 한국어로 작성됩니다. 검색은 한국어 + 영어 모두 수행합니다.
