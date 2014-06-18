(function() {
  angular.module("gvdoodle", []).controller("EditorCtrl", [
    '$scope', '$http', '$sce', function($scope, $http, $sce) {
      var editor, loadSVG, self;
      window.editor = editor = ace.edit("editor");
      editor.setTheme("ace/theme/tomorrow");
      editor.getSession().setMode("ace/mode/dot");
      editor.focus();
      self = this;
      loadSVG = function(data, status) {
        $scope.svg = $sce.trustAsHtml(data);
        self.show_preview = true;
        return console.log(['success', data]);
      };
      this.loadSaved = function(gvid) {
        return $http.get("/" + gvid + ".svg").success(loadSVG);
      };
      this.engine = 'dot';
      this.preview = 'preview.svgz';
      this.engines = ['dot', 'neato', 'fdp', 'sfdp', 'twopi', 'circo'];
      this.run = function(e) {
        return $http.post("/preview", {
          text: editor.getValue(),
          engine: self.engine
        }).success(loadSVG).error(function(res) {
          return console.log(['error', res]);
        });
      };
      this.load = function(id) {
        $http.get("/" + id + ".gv").success(function(data, status) {
          editor.setValue(data);
          return editor.clearSelection();
        });
        $http.get("/" + id + ".meta").success(function(data, status) {
          if (data && data.engine) {
            return self.engine = data.engine;
          }
        });
        this.svg_url = "/" + id + ".svgz";
        self.show_preview = false;
        return console.log(id);
      };
      return this;
    }
  ]);

}).call(this);

//# sourceMappingURL=app.js.map
