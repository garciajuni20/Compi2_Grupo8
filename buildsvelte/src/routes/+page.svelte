<script lang="ts">
    import parseInput from "$lib/parser";
    import CodeMirror from "svelte-codemirror-editor";
    import { oneDark } from "@codemirror/theme-one-dark";

    let editor = "";
    let textoResultado = "";

    // Configuración del editor
    let extensions = [oneDark];

    function parse() {
        textoResultado = parseInput(editor);
    }
</script>

<style>
    .html, .body {
        margin: 0;
        padding: 0;
        height: 100%;
        width: 100%;
    }

    .html {
        display: flex;
        flex-direction: column;
        height: 100vh;
        overflow: hidden;
        background-color: rgb(13, 17, 23);
        font-family: Arial, sans-serif;
        font-size: 11pt;
        color: white;
    }

    .body {
        display: flex;
        flex-direction: column;
        height: 100%;
        width: 100%;
    }

    .filas {
        display: flex;
        flex-direction: column;
        justify-content: space-between;
        height: 100%;
        width: 100%;
    }

    .columnas {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        gap: 1vh;
        flex: 1;
        padding: 1rem;
    }

    .codearea {
        padding: 0.5rem;
        font-size: 11pt;
        height: 100%;
        overflow: auto;
        border-radius: 5px;
        background-color: rgb(40, 44, 52);
        font-family: 'Consolas';
    }

    .botones {
        margin: 1rem;
        display: flex;
        flex-direction: row;
        column-gap: 1vh;
        justify-content: baseline;
        align-items: center;
    }

    .boton {
        background-color: rgb(17, 107, 247);
        border: 0 solid rgb(17, 107, 247);
        border-radius: 5px;
        color: white;
        cursor: pointer;
        text-align: center;
        height: 3.5vh;
        width: 12%;
        transition: all 0.3s ease;
    }

    .boton:hover {
        background-color: rgb(11, 94, 215);
    }

    .boton:active {
        background-color: rgb(11, 94, 215);
    }

    .grupo {
        display: flex;
        flex-direction: column;
        align-items: center; /* Centrar el texto del grupo */
        margin: 1rem 0;
    }

    .grupo #title {
        font-size: 16pt;
        font-weight: bold;
        margin-bottom: 0.5rem;
    }

    .grupo #names {
        display: flex;
        justify-content: space-between; /* Espaciado entre nombres */
        width: 100%; /* Ocupar todo el ancho */
        padding: 0 1rem; /* Espaciado horizontal */
        font-size: 10pt;
    }
</style>

<div class="html">
    <div class="body">
        <div class="filas">
            <div class="grupo">
                <div id="title">FortranPEG - G8</div>
                <div id="names">
                    <span>Khristian Manolo Junior Garcia Pineda - 201404202</span>
                    <span>Brandon Josué Pinto Méndez - 3155412531301</span>
                    <span>Susan Pamela Herrera Monzon - 201612218</span>
                </div>
            </div>
            <div class="botones">
                <button class="boton" on:click={parse}>Analizar</button>
            </div>
            <div class="columnas">
                <div class="codearea">
                    <CodeMirror bind:value={editor} {extensions} />
                </div>
                <div class="codearea">
                    <p>{textoResultado}</p>
                </div>
            </div>
        </div>
    </div>
</div>
