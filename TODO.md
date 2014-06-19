TODO
==========
* 500.html 작성
* 프리뷰에 img태그로 넣을 경우, 파일을 꼭 생성해야하는 문제. POST  /preview 방식이 안된다. (세션을 써야하나?)
* ACE 에디터 본문 부분이 깜빡이는 것이 거슬림
* 똑같은 소스라면 같은 gvID를 발급할까? 아니면 최소한 공간 절약이라도?
* window.localStorage 이용해서 히스토리 제공
* 손님용 화면 먼저 구현. 저장 때마다 새로운 gvID 발급.
* 로그인 사용자는 저장 때마다 새로 발급하고, 기존 것은 리스트에서 가림. 리비전 카운트를 표시할까?
* 엔진 사용시 옵션 지정
* 엔진간 파이프 연결 <http://www.graphviz.org/Gallery/undirected/gd_1994_2007.html>
* gv 실행 타임아웃 확인 및 설정
* Crockford Base32 정리

.gv samples
------------
* <http://www.graphviz.org/Gallery/directed/unix.gv.txt>
* <http://www.graphviz.org/Gallery/directed/crazy.gv.txt>
* <http://www.graphviz.org/content/cluster>
* <http://www.graphviz.org/Gallery/directed/datastruct.gv.txt>
* <http://www.graphviz.org/Gallery/directed/fsm.gv.txt>

FIX
===========


DONE
===========
* svg에 로고 첨부
* 스토리지 API를 그대로 쓰자. https://developers.google.com/storage/docs/json_api/v1/objects/insert
* svg 프리뷰에 xml 그대로 넣던 것을 img 태그에 src로 바꾸자. (img태그로도 링크 잘 걸린다)
* 테스팅 단계임을 공지 (특정시점에 데이터 삭제예정)
* 불필요 모듈 및 소스/스펙 제거 (eg. nodegit)
* gvID 판별 RE작성
* img태그에서 svg사용 가능한 브라우저: http://caniuse.com/svg-img (현재 전부)
* 도메인등록 (후보: gvdoodle.com + gvd.kr, graphdoodle.com, gvfiddle.com, gvbin.com, graphviz-online.com, gvo.kr, gvon.in)
* SVG 웹페이지에 그릴 때 크기 조절 (너무 큰 경우 축소, viewBox를 유지한채, width/height를 조정하면 됨.)
* [GTS](http://gts.sourceforge.net/) 추가해서 graphviz 빌드: ```brew install graphviz --with-gts```
* SVG 좌표 소수점 오류 표기되는 원인 찾기 (리눅스에서는 괜찮지 않나?) -> spawn결과 join의 문제였음. ```String#join()```은 기본 ,로 붙여짐. join('')로 호출해야 함.
* SVG 가져온 것 임베딩시 한글 깨짐
* Sankey diagram으로 표현해보기
