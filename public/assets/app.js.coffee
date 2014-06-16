  angular.module("holiday", [])
    .controller "LoginCtrl", () ->
      this.welcome = "환영합니다"
      this
    .controller "D3Ctrl", ['$scope', '$http', ($scope, $http) ->
      this.tab = "sankey"
      $scope.content = ''
      this.selectTab = (t) ->
        this.tab = t
        console.log ["sankey 클릭됨", t]
        if t == 'sankey'
          $http.get('/d3/sankey').success (r) ->
            $scope.content = r
      this.isSelected = (t) ->
        this.tab == t
      this
    ]
    .controller "EditorCtrl", ['$scope', '$http', '$sce', ($scope, $http, $sce) ->
      window.editor = editor = ace.edit("editor")
      # editor.setTheme("ace/theme/clouds")
      editor.setTheme("ace/theme/tomorrow")
      # editor.setTheme("ace/theme/crimson_editor")
      editor.getSession().setMode("ace/mode/dot")
      # editor.getSession().setUseWrapMode true
      editor.focus()

      self = this
      loadSVG = (data, status) ->
        $scope.svg = $sce.trustAsHtml(data)
        self.show_preview = true
        console.log ['success', data]
        # $('#output svg').attr("width", "100%").attr("height", "100%")

      this.loadSaved = (gvid) ->
        $http.get("/#{gvid}.svg").success(loadSVG)
      this.engine = 'dot'
      this.preview = 'preview.svgz'
      this.engines = ['dot', 'neato', 'fdp', 'sfdp', 'twopi', 'circo']
      this.run = (e) ->
        # $http.defaults.headers.post["Content-Type"] = "text/plain"
        $http.post("/preview.svg", {
          text: editor.getValue()
          engine: self.engine
        }).success(loadSVG).error (res) ->
          console.log ['error', res]
      this.load = (id) ->
        $http.get("/#{id}.gv").success((data, status) ->
          console.log data
          editor.setValue data
          editor.clearSelection()
        )
        $http.get("/#{id}.meta").success((data, status) ->
          if data && data.engine
            console.log data.engine
            self.engine = data.engine
        )
        this.svg_url = "/#{id}.svgz"
        self.show_preview = false
        console.log id
      this
    ]
