TODO
==========
* store.gvdoodle.com 대신 단축도메인 (gvdo.co or gvd.kr) 구매할까?
* examples 페이지 별도 작성 (프리뷰와 함께)
* 500.html 작성
* ACE 에디터 본문 부분이 깜빡이는 것이 거슬림
* window.localStorage 이용해서 히스토리 제공
* 손님용 화면 먼저 구현. 저장 때마다 새로운 gvID 발급.
* 로그인 사용자는 저장 때마다 새로 발급하고, 기존 것은 리스트에서 가림. 리비전 카운트를 표시할까?
* 엔진 사용시 옵션 지정
* 엔진간 파이프 연결 <http://www.graphviz.org/Gallery/undirected/gd_1994_2007.html>
* gv 실행 타임아웃 확인 및 설정
* Crockford Base32 정리


FIX
===========
* nginx proxy cache에 gzip 데이타가 남는데, 이후 전송될때는 gzip인코딩으로 전송되지 않음

DONE
===========
* img태그에서 svg사용 가능한 브라우저: http://caniuse.com/svg-img (현재 전부)
* SVG 웹페이지에 그릴 때 크기 조절 (너무 큰 경우 축소, viewBox를 유지한채, width/height를 조정하면 됨.)
* [GTS](http://gts.sourceforge.net/) 추가해서 graphviz 빌드: ```brew install graphviz --with-gts```
