<script lang="ts">
  import parseInput from "$lib/parser";
  import CodeMirror from "svelte-codemirror-editor";

  let editor = "";
  let textoResultado = "";

  function parse() {
    textoResultado = parseInput(editor);
  }
</script>

<div
  class="d-flex justify-content-center align-items-center bg-light col-12 overflow-hidden"
  style="height: 100vh;"
>
  <div
    class="d-flex justify-content-center rounded align-items-center flex-column col-5 m-4 overflow-x-auto bg-light border border-secondary-subtle"
    style="height: 80vh;"
  >
    <div class="w-100" style="height: 75vh;">
      <CodeMirror bind:value={editor} />
    </div>
    <button class="btn btn-primary m-2" on:click={parse}> Analizar</button>
  </div>
  <div
    class="bg-light col-5 rounded border border-secondary-subtle m-4"
    style="height: 80vh;"
  >
    <p>
      {textoResultado}
    </p>
  </div>
</div>
