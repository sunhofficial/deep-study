<h1 align="center">Deep Study</h1>

<p align="center">
  <strong>한 줄 명령어 → 10개 이상의 Obsidian 학습 노트. 자동으로.</strong>
</p>

<p align="center">
  <a href="#설치">설치</a> •
  <a href="#사용법">사용법</a> •
  <a href="#동작-과정">동작 과정</a> •
  <a href="#출력-결과">출력 결과</a> •
  <a href="#english">English</a>
</p>

---

회사에서 처음 보는 코드를 만나셨나요? 구글링하고, 탭 15개 열고, 대충 훑고... 금요일이면 다 까먹으시죠.

**Deep Study**는 이 과정을 명령어 한 줄로 압축해 드립니다 — 그리고 진짜 다시 볼 수 있는 Obsidian 노트로 남겨 줍니다.

```
/deep-study WKWebView
```

커피 한 잔 마시고 오시면 **10개 이상의 딥다이브 노트**가 준비되어 있습니다. 아키텍처 다이어그램, 프로덕션 코드, 트러블슈팅 가이드, 퀴즈까지 — 전부 위키링크로 연결되어 Obsidian에서 바로 열립니다.

---

## 설치

```bash
claude plugin add sunhofficial/deep-study
```

<details>
<summary>다른 방법: git clone으로 설치</summary>

```bash
git clone https://github.com/sunhofficial/deep-study.git
claude skill add ./deep-study/skills/deep-study
```

</details>

### 필요한 도구

| 도구 | 설치 |
|------|------|
| [Claude Code](https://docs.anthropic.com/en/docs/claude-code) | `npm install -g @anthropic-ai/claude-code` |
| [Obsidian](https://obsidian.md/) | 사이트에서 다운로드 |
| [notebooklm-py](https://github.com/nicholasgasior/notebooklm-py) | `pipx install "notebooklm-py[browser]"` |

<details>
<summary><strong>NotebookLM 인증 (최초 1회)</strong></summary>

notebooklm-py 설치 후 Google 계정으로 인증해 주세요:

```bash
notebooklm login
```

브라우저에서 Google 로그인하시면 끝입니다. 이후에는 스킬이 자동으로 인증 상태를 확인해 줍니다.

</details>

<details>
<summary><strong>권장: Bash 권한 허용</strong></summary>

Deep Study는 NotebookLM CLI 등 Bash 명령어를 자주 실행합니다. 중간에 권한 팝업 없이 실행하시려면:

```bash
claude config set --project allowedTools "Bash(*)"
```

</details>

---

## 사용법

직접 명령어를 입력하거나, 자연스럽게 대화하면 자동으로 실행됩니다.

### 직접 실행

```
/deep-study {주제}
```

### 자동 트리거

아래처럼 말하면 Deep Study가 자동으로 시작됩니다:

```
WKWebView 공부하고 싶어
Swift Concurrency 딥다이브 해줘
Jetpack Compose가 내부적으로 어떻게 동작하는지 알고 싶어
React Server Components 깊이 파보고 싶어
how does Core Data work under the hood?
study WebSocket
```

코드를 읽다가 모르는 개념을 만났을 때, 기술의 내부 동작 원리가 궁금할 때, 면접 준비를 위해 깊이 있게 정리하고 싶을 때 — 자연스럽게 물어보시면 됩니다.

### 첫 실행 시 프로필 설정

처음 한 번만 물어보고, `~/.config/deep-study/config.json`에 저장됩니다. 이후에는 다시 묻지 않습니다:

| 설정 | 선택지 | 영향 |
|------|--------|------|
| **경험 수준** | `junior` · `mid` · `senior` | 노트 깊이, 코드 예시 스타일, 퀴즈 난이도가 달라집니다 |
| **플랫폼** | `ios` · `android` · `web-frontend` · `web-backend` | 검색 키워드, 오픈소스 레퍼런스, 면접 질문이 달라집니다 |
| **언어** | `swift` · `kotlin` · `typescript` · `python` | 코드 예시가 선택한 언어로 작성됩니다 |

<details>
<summary><strong>경험 수준별 차이 보기</strong></summary>

| | junior | mid | senior |
|---|--------|-----|--------|
| **선수 지식** | 상세 설명 + 링크 | 키워드 + 한 줄 | 생략 (이미 안다고 가정) |
| **난이도 비율** | 필수 70% | 균형 | 심화 50% 이상 |
| **노트 깊이** | 기초부터 단계별 | "왜" + 실무 패턴 | 내부 구현 / 소스 레벨 |
| **코드 예시** | 주석 많이 | 프로덕션 레벨 | 핵심만 |
| **퀴즈** | 개념 확인 위주 | 균형 | 분석/면접 위주 |

</details>

---

## 동작 과정

명령어 하나로 4단계가 자동 실행됩니다. **중간에 확인을 묻지 않습니다.**

### Phase 1: 프로젝트 코드 분석

현재 작업 중인 프로젝트에서 주제와 관련된 코드를 찾아줍니다.

- 파일명, 클래스명, import, 함수명으로 검색합니다
- 관련 파일을 읽고 사용 패턴을 분석합니다
- 장점과 개선 포인트를 정리해 줍니다

> 프로젝트 디렉토리가 아니면 이 단계는 자동으로 건너뜁니다.

### Phase 2: 학습 자료 수집

웹에서 8~15개의 고품질 자료를 자동으로 수집합니다.

- **공식 문서** — Apple Developer Docs, MDN 등을 최우선으로 수집합니다
- **블로그/아티클** — 한국어 + 영어로 모두 검색합니다
- **YouTube** — WWDC, Google I/O, 컨퍼런스 영상을 찾아줍니다
- **오픈소스** — 잘 구현된 프로젝트의 특정 파일/모듈 링크를 수집합니다

### Phase 3: NotebookLM 통합

수집한 자료를 Google NotebookLM에 넣고, AI가 다음을 생성해 줍니다:

| 생성물 | 설명 |
|--------|------|
| **Study Guide** | 주제별로 정리된 학습 가이드 (한국어) |
| **Quiz** | 객관식 퀴즈 10문항 |
| **Flashcards** | 핵심 개념 플래시카드 |
| **Infographic** | 시각적 개념 정리 이미지 (PNG) |
| **Mind Map** | 주제 구조 마인드맵 (Mermaid 다이어그램으로 변환) |

### Phase 4: Obsidian 노트 생성

Phase 1~3의 결과를 종합해서 **멀티노트 Obsidian 출력**을 작성해 줍니다.

- 주제를 실무 고민 단위로 8~12개 노트로 분리합니다
- 각 노트에 Mermaid 다이어그램, 프로덕션 코드, 트러블슈팅을 포함합니다
- 모든 노트를 `[[위키링크]]`로 양방향 연결합니다
- 접이식 퀴즈(정답 숨김)를 자동 생성합니다
- 완료 후 Obsidian에서 MOC(학습 맵)를 자동으로 열어 줍니다

---

## 출력 결과

실제로 `/deep-study WKWebView`를 실행한 결과입니다:

```
Deep Study/WKWebView/
  assets/infographic.png              ← NotebookLM 인포그래픽
  00-MOC.md                           ← 학습 맵 + 마인드맵 + 자료 링크
  01-멀티프로세스 아키텍처.md           ← Mach 포트 기반 IPC 동작 원리
  02-WKWebViewConfiguration과 생명주기.md
  03-SwiftUI 통합 (UIViewRepresentable).md
  04-JavaScript 브릿지.md
  05-WKContentWorld와 스크립트 격리.md
  06-Navigation과 로딩 제어.md
  07-쿠키와 세션 관리.md
  08-프로세스 종료와 빈 화면 복구.md
  09-보안 (App-bound Domains, ITP).md
  10-성능 최적화와 예열.md
  11-우리 프로젝트 분석.md              ← 현재 코드 분석 + 개선안
  Practice.md                          ← 접이식 퀴즈 15문제
```

### 각 개념 노트의 구조

일반적인 API 나열이 아닙니다. **프레임워크 소스 코드를 읽은 수준의 깊이**를 목표로 합니다:

| 섹션 | 내용 |
|------|------|
| **핵심 요약** | 3줄 TL;DR — 이것만 읽어도 뭔지 알 수 있습니다 |
| **상세 설명** | 내부 동작 원리 + 설계 배경 + Mermaid 다이어그램 |
| **실전 코드** | 기본 사용법 → 프로덕션 레벨 (복사해서 바로 사용 가능) |
| **트러블슈팅** | 실제 프로덕션에서 발생하는 버그 + 근본 원인 분석 |
| **오픈소스 레퍼런스** | 잘 구현된 오픈소스의 특정 파일 링크 |
| **Related** | `[[위키링크]]`로 관련 노트 연결 |

### Practice.md (퀴즈)

정답은 기본으로 숨겨져 있습니다 (Obsidian 접이식 callout):

```markdown
## Q1 - 멀티프로세스 구조 [recall]
> WKWebView가 사용하는 3개의 프로세스 이름과 역할을 설명하세요.

> [!answer]- 정답 보기
> 1. App Process: WKWebView 객체 관리...
> 2. WebContent Process: DOM 파싱, JS 실행...
> 3. Networking Process: HTTP 요청, 쿠키...
> [[01-멀티프로세스 아키텍처]]
```

문제 유형은 4가지입니다: `[recall]` 개념 확인 / `[application]` 실무 적용 / `[analysis]` 비교 분석 / `[interview]` 면접 대비

---

## 주의사항

- **NotebookLM**은 [비공식 API](https://github.com/nicholasgasior/notebooklm-py)를 사용합니다. 무료 일일 생성 한도가 있습니다.
- **소스 실패**는 흔합니다 (Medium, 유료 사이트 등). 스킬이 자동으로 대체 URL을 찾아줍니다.
- **시각 자료** (인포그래픽, 마인드맵)는 가끔 생성에 실패할 수 있습니다. 실패해도 나머지는 정상 진행됩니다.
- **노트는 한국어**로 작성됩니다. 검색은 한국어 + 영어 모두 수행합니다.

---

## 피드백 & 기능 요청

원하시는 기능이나 개선 아이디어가 있으시면 언제든 환영합니다!

- [GitHub Issues](https://github.com/sunhofficial/deep-study/issues)에 남겨 주세요
- 버그 리포트, 기능 제안, 사용 후기 모두 감사합니다

## License

MIT

---

<details>
<summary><h2 id="english">English Guide</h2></summary>

### What is this?

**Deep Study** is an all-in-one research skill for Claude Code. Tell it what you want to study, and it will:

1. Scan your project for topic-related code
2. Collect 8-15 learning resources from the web
3. Generate study guide + quiz + flashcards + infographic via NotebookLM
4. Write 10+ interconnected Obsidian notes with Mermaid diagrams

### Install

```bash
claude plugin add sunhofficial/deep-study
```

### Usage

```
/deep-study {topic}
```

That's it. Fully automatic — no confirmations between phases.

### What You Get

```
Deep Study/{topic}/
  00-MOC.md            ← Learning map + resources + mind-map
  01~10-concepts.md    ← Internal mechanics + diagrams + production code
  11-project.md        ← Your codebase analysis + improvements
  Practice.md          ← 15 collapsible quiz questions
```

### Prerequisites

| Tool | Install |
|------|---------|
| [Claude Code](https://docs.anthropic.com/en/docs/claude-code) | `npm install -g @anthropic-ai/claude-code` |
| [Obsidian](https://obsidian.md/) | Download from site |
| [notebooklm-py](https://github.com/nicholasgasior/notebooklm-py) | `pipx install "notebooklm-py[browser]"` then `notebooklm login` |

### Profile Setup (first run only)

| Setting | Options |
|---------|---------|
| **Level** | `junior` · `mid` · `senior` |
| **Platform** | `ios` · `android` · `web-frontend` · `web-backend` |
| **Language** | `swift` · `kotlin` · `typescript` · `python` |

### How Phases Work

| Phase | What Happens |
|-------|-------------|
| **1. Code Scan** | Searches your project for topic-related patterns |
| **2. Web Search** | Collects 8-15 URLs (docs, blogs, YouTube, open-source) |
| **3. NotebookLM** | Generates study guide, quiz, flashcards, infographic, mind-map |
| **4. Obsidian** | Writes 10+ notes with wikilinks, diagrams, quiz → auto-opens MOC |

### Caveats

- **NotebookLM** uses an [unofficial API](https://github.com/nicholasgasior/notebooklm-py). Free tier has daily limits.
- **Source failures** are common. The skill auto-replaces failed URLs.
- **Notes are in Korean** by default. Searches run in Korean + English.

</details>
