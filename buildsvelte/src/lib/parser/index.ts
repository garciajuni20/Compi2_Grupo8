import * as Parser from './peg-parser';

export default function parseInput(entrada: string) {
    try {
        Parser.parse(entrada);
    } catch (e) { 
        return e as string;
    }
    return "Todo correcto";
 }