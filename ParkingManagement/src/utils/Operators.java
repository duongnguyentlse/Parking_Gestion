package utils;

public enum Operators {
	CREATE("-c"), 
	READ("-r"), 
	DELETE("-d"), 
	INSERT("-in"), 
	REMOVE("-out");

	private String operator;

	Operators(final String operator) {
		this.operator = operator;
	}

	public String getOperator() {
		return this.operator;
	}
}
