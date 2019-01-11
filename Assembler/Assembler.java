import java.io.*;
import java.util.ArrayList;
import java.util.Arrays;

public class Assembler{

    // This s for getting the OPCODE hexadecimal values from their indexes.
    private String[] opCodes = {"AND", "ADD", "ANDI", "ADDI", "CMP", "LD", "ST", "JUMP", "JE", "JA", "JB", "JBE", "JAE"};

    public static void main(String[] args){

        Assembler assembler = new Assembler();
        assembler.run();
    }

    /**
     * to save the project from static form
     */
    private void run(){

        File inputFile, outputFileVerilog, outputFileLogisim;

        ArrayList<String> outputList = new ArrayList<>();

        try{
            inputFile = new File("Input.txt");
            if(!inputFile.exists()){
                System.out.println("The File does not exist !");
            }else{
                // TODO READ INPUT FILE
                BufferedReader bufferedReader = new BufferedReader(new FileReader(inputFile));

                String instruction;

                while((instruction = bufferedReader.readLine()) != null){
                    outputList.add(parseInstruction(instruction));
                }

                //TODO WRITE OUTPUT FILE
                outputFileVerilog = new File("Instruction Memory_Verilog.txt");
                outputFileLogisim = new File("Instruction Memory Logisim.txt");

                if(!outputFileVerilog.exists()){
                    if(!outputFileVerilog.createNewFile())
                        System.out.println("File Creation Error !");
                }if(!outputFileVerilog.exists()){
                    if(!outputFileLogisim.createNewFile())
                        System.out.println("File Creation Error !");
                }

                BufferedWriter bufferedWriterVerilog = new BufferedWriter(new FileWriter(outputFileVerilog));
                BufferedWriter bufferedWriterLogisim = new BufferedWriter(new FileWriter(outputFileLogisim));

                bufferedWriterLogisim.write("v2.0 raw" + System.lineSeparator());

                for(int i = 0; i < outputList.size(); i++){
                    bufferedWriterVerilog.write(outputList.get(i) + ((i + 1 < outputList.size()) ? System.lineSeparator() : ""));
                    bufferedWriterLogisim.write(outputList.get(i) + ((i + 1 < outputList.size()) ? System.lineSeparator() : ""));
                }

                bufferedReader.close();
                bufferedWriterVerilog.close();
                bufferedWriterLogisim.close();
            }

        }catch(Exception e){
            e.printStackTrace();
        }
    }


    /**
     * Parsing the instruction
     */
    private String parseInstruction(String str){
        String temp = str.replaceAll("R", "");

        String firstSplit[] = temp.split(" ");
        String paramsPart[] = firstSplit[1].split(",");

        int[] paramsPartConverted = Arrays.stream(paramsPart).mapToInt(Integer::parseInt).toArray();

        String opCodeHex = getOPCODEHexadecimal(firstSplit[0].toUpperCase());

        return opCodeHex + calculateParams(opCodeHex, paramsPartConverted);
    }

    /**
     * Converting OPCODE string to hexadecimal
     */
    private String getOPCODEHexadecimal(String opCode){

        for(int i = 0; i < opCodes.length; i++){
            if(opCode.equalsIgnoreCase(opCodes[i])){
                return convertHex(i);
            }
        }

        return null;
    }

    /**
     * convert integer value to HEX string
     */
    private String convertHex(int value){
        return Integer.toHexString(value).toUpperCase();
    }

    /**
     * Calculating the hex value of params part.
     */
    private String calculateParams(String opCode, int[] arr){
        StringBuilder stringBuilder = new StringBuilder();

        switch(opCodes[Integer.parseInt(opCode, 16)]){
            case "AND":
            case "ADD":

                stringBuilder.append(convertHex(arr[0])); //DST
                stringBuilder.append(convertHex(arr[1])); //SRC1
                stringBuilder.append(convertHex(arr[2])); //SRC2

                break;
            case "ANDI":
            case "ADDI":

                stringBuilder.append(convertHex(arr[0])); //DST
                stringBuilder.append(convertHex(arr[1])); //SRC1
                stringBuilder.append(convertHex(twosComplementIntegerConverter(arr[2]))); //IMM

                break;
            case "CMP":

                stringBuilder.append(0); //IGNORE PART
                stringBuilder.append(convertHex(arr[0])); //SRC1
                stringBuilder.append(convertHex(arr[1])); //SRC2

                break;
            case "LD":

                stringBuilder.append(convertHex(arr[0])); //DST
                stringBuilder.append(twoBitExtender(convertHex(arr[1]))); //ADDRESS

                break;
            case "ST":

                stringBuilder.append(convertHex(arr[0])); //SRC
                stringBuilder.append(twoBitExtender(convertHex((arr[1])))); //ADDRESS

                break;
            case "JUMP":
            case "JE":
            case "JA":
            case "JB":
            case "JBE":
            case "JAE":

                stringBuilder.append(threeBitExtender(convertHex(twosComplementIntegerConverter(arr[0])), arr[0])); //ADDRESS

                break;
        }

        return stringBuilder.toString();
    }

    private String twoBitExtender(String input){
        if(input.length() < 2)
            return String.valueOf("0" + input);

        return input;
    }

    private String threeBitExtender(String input, int inputValue){
        if(input.length() < 2){
            if(inputValue > 0)
                return String.valueOf("00" + input);
            else
                return String.valueOf("FF" + input);
        }else if(input.length() == 2){
            if(inputValue > 0)
                return String.valueOf("0" + input);
            else
                return String.valueOf("F" + input);
        }

        return input;
    }

    /**
     * @param decimal // IMMEDIATE VALUE
     *                Taking twos complement of an integer.
     */
    private int twosComplementIntegerConverter(int decimal){

        if(decimal < 0){
            String temp = Integer.toBinaryString(decimal).substring(28, 32);
            return Integer.parseInt(temp, 2);
        }
        return decimal;
    }
}
