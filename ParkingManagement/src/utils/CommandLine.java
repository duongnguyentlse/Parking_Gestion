package utils;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;

public class CommandLine {
	private static final String PATH = "ParkingManagement/src/ocaml/";
	private static final String PROCESS_NAME = "crudocaml.exe";

	public static String[] processCmd(final Operators operators, final String fileName, final String params) {
		String[] lines = new String[0];
		try {
			Process process = new ProcessBuilder(PATH + PROCESS_NAME, operators.getOperator(),
					params + " " + PATH + fileName).start();
			InputStream is = process.getInputStream();
			InputStreamReader isr = new InputStreamReader(is);
			BufferedReader br = new BufferedReader(isr);
			lines = br.lines().filter(line -> line != null && !line.strip().isEmpty()).toArray(String[]::new);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return lines;
	}

	public static String[] processCmd(final Operators operators, final String fileName) {
		String[] lines = new String[0];
		try {
			Process process = new ProcessBuilder(PATH + PROCESS_NAME, operators.getOperator(), PATH + fileName).start();
			InputStream is = process.getInputStream();
			InputStreamReader isr = new InputStreamReader(is);
			BufferedReader br = new BufferedReader(isr);
			lines = br.lines().filter(line -> line != null && !line.strip().isEmpty()).toArray(String[]::new);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return lines;
	}
}
