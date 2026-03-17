# E-commerce Product Analytics
### SQL-Based Funnel, Retention, and User Journey Analysis

> SQL 기반으로 사용자 행동 로그를 분석해 전환 병목과 초기 이탈 문제를 진단하고, 핵심 KPI와 개선 액션을 도출한 Product Analytics 프로젝트입니다.

---

## 1. Business Problem

이커머스 서비스에서는 많은 사용자가 상품을 조회하지만 실제 구매까지 이어지지 않는 경우가 많습니다.  
또한 첫 방문 이후 빠르게 이탈하는 사용자가 많다면, 단순 유입 확대만으로는 성장을 만들기 어렵습니다.

이 프로젝트는 다음 두 가지 문제를 가정하고 시작했습니다.

- 어디에서 전환이 가장 크게 이탈하는가?
- 초기 사용자 이탈은 어떤 패턴으로 발생하는가?

즉, **전환율과 초기 리텐션을 함께 분석해 서비스 개선 우선순위를 도출하는 것**이 본 프로젝트의 목표입니다.

---

## 2. Business Questions

이 프로젝트는 아래 질문에 답하는 것을 목표로 했습니다.

1. 사용자는 `view → cart → purchase` 퍼널에서 어느 단계에서 가장 많이 이탈하는가?
2. 구매 직전 사용자는 어떤 행동 패턴을 보이는가?
3. 첫 유입 이후 사용자는 얼마나 다시 돌아오는가?
4. 어떤 KPI를 우선적으로 관리해야 서비스 개선에 효과적인가?

---

## 3. Core KPIs

이 분석에서 핵심적으로 본 지표는 다음과 같습니다.

- **View-to-Cart Conversion Rate**  
  상품 조회 후 장바구니 진입 비율
- **Cart-to-Purchase Conversion Rate**  
  장바구니 진입 후 구매 전환 비율
- **First-Week Retention Rate**  
  첫 유입 후 1주차 재방문/재행동 유지율
- **Purchase Journey Composition**  
  구매 이전 행동 흐름에서 각 이벤트가 차지하는 비중

이 지표들은 단순 조회 수보다 **실제 전환과 초기 잔존을 설명하는 운영 지표**로 활용할 수 있습니다.

---

## 4. Dataset

> Kaggle의 이커머스 이벤트 로그 데이터를 활용했으며, 대용량 원천 데이터를 SQL 기반으로 분석 가능한 형태로 가공했습니다.

- Source: E-commerce event log data (https://www.kaggle.com/datasets/mkechinov/ecommerce-behavior-data-from-multi-category-store)
- Events: `view`, `cart`, `purchase`
- Raw size: 약 67M rows
- Processing: chunk-based random sampling and SQL-ready structuring

### Data fields used
- `user_id`
- `event_type`
- `event_time`
- `product_id`
- `category_code`
- `price`

---

## 5. Analysis Approach

본 프로젝트는 SQL을 중심으로 아래 3가지 분석을 수행했습니다.

### A. Funnel Analysis
사용자의 주요 행동 이벤트를 기준으로 전환 구조를 측정했습니다.

- `view → cart`
- `cart → purchase`

이를 통해 **전환 병목 구간**을 식별했습니다.

### B. Pre-purchase Behavior Analysis
구매 이전에 사용자가 어떤 행동을 많이 거치는지 분석했습니다.

이를 통해 **상품 상세 경험과 구매 의사결정의 관계**를 해석했습니다.

### C. Weekly Cohort Retention
첫 행동 시점을 기준으로 코호트를 나누고, 주차별 재행동 여부를 측정했습니다.

이를 통해 **초기 유입 이후 빠른 이탈이 발생하는지** 확인했습니다.

---

## 6. Key Findings

### 1) Largest drop-off occurs between view and cart
![Funnel Chart](outputs/funnel_chart.png)
퍼널 분석 결과, 가장 큰 이탈은 `view → cart` 구간에서 발생했습니다.

- 사용자는 상품을 조회하지만 장바구니에 담기까지 충분히 이어지지 않았습니다.
- 반면 장바구니에 진입한 이후 구매 전환은 상대적으로 높았습니다.

**해석**  
문제의 핵심은 구매 직전 단계보다, **상품 상세 페이지 또는 초기 탐색 경험에서의 마찰**에 있을 가능성이 높습니다.

---

### 2) Product view plays a dominant role before purchase
![Journey Chart](outputs/pre_purchase_chart.png)
구매 이전 행동 흐름을 보면 `view` 비중이 가장 높았고, 일부 사용자는 짧은 상호작용 이후 구매로 이어졌습니다.

**해석**  
상품 상세 페이지 경험, 정보 구성, CTA 배치가 전환율에 직접적인 영향을 줄 가능성이 큽니다.

---

### 3) Retention drops sharply after week 1
![Cohort Heatmap](outputs/weekly_cohort_chart.png)
코호트 리텐션 분석 결과, 대부분 코호트에서 1주차 이후 잔존율이 빠르게 하락했습니다.

**해석**  
초기 방문 이후 재방문을 유도할 장치가 충분하지 않으며, 첫 경험 이후 사용자 관계가 빠르게 약해지는 구조일 수 있습니다.

---

## 7. Business Implications

이 분석을 통해 확인한 핵심 시사점은 다음과 같습니다.

- 전환율 개선의 우선순위는 **view → cart 구간**
- 구매 전환을 높이기 위해서는 **상품 상세 경험 최적화**가 중요
- 단기 전환뿐 아니라 **first-week retention 개선**이 장기 성장에 필요

즉, 이 프로젝트는 단순 퍼널 확인이 아니라  
**“어떤 지표를 먼저 개선해야 하는가”를 도출하는 Product Analytics 케이스**로 볼 수 있습니다.

---

## 8. Recommended Actions

### Action 1. Product page A/B test
상품 상세 페이지에서 아래 요소를 실험 대상으로 설정할 수 있습니다.

- CTA 문구 및 위치
- 가격/혜택 정보 노출 방식
- 리뷰/평점 강조 방식

**Expected metric**
- View-to-cart conversion rate

### Action 2. First-week re-engagement campaign
초기 유입 후 빠르게 이탈하는 사용자를 대상으로 재방문 유도 메시지 또는 개인화 추천을 설계할 수 있습니다.

**Expected metric**
- First-week retention rate

### Action 3. Funnel monitoring dashboard
핵심 전환 지표와 초기 리텐션을 지속적으로 모니터링할 수 있는 리포트/대시보드로 확장 가능합니다.

**Expected metric**
- Funnel conversion trend
- Retention trend by cohort

---

## 9. Why SQL Was Important

이 프로젝트는 SQL을 활용해 대용량 이벤트 로그를 구조화하고,  
행동 데이터를 **퍼널 / 코호트 / 구매 전 여정 단위로 해석 가능한 분석 결과**로 전환하는 데 초점을 맞췄습니다.

핵심은 단순 쿼리 작성이 아니라,  
**사용자 행동을 서비스 KPI 관점에서 재구성하고 인사이트를 도출하는 것**이었습니다.

---

## 10. Tech Stack

- SQL (DuckDB)
- Python (Pandas, Matplotlib)
- Google Colab

---

## 11. Project Structure

```text
ecommerce-product-analytics/
│
├── ecommerce_product_analytics.ipynb
├── sql/
│   ├── funnel_analysis.sql
│   ├── pre_purchase_analysis.sql
│   └── cohort_retention.sql
│
├── outputs/
│   ├── funnel_chart.png
│   ├── pre_purchase_chart.png
│   └── weekly_cohort_chart.png
│
└── README.md
```

---

##  12. Key Takeaways

본 프로젝트를 통해 다음과 같은 Product Analytics 역량을 검증하였다.

- SQL 기반으로 대용량 사용자 행동 로그를 구조화하고 퍼널 및 코호트 리텐션 분석 수행
- 전환 병목과 초기 이탈 문제를 핵심 KPI 중심으로 정의하고 해석
- 분석 결과를 A/B 테스트 및 리텐션 개선 액션으로 연결
- 문제 정의부터 분석, 실행 가능한 액션 제안까지 end-to-end 분석 수행

