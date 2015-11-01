package generators;

import java.security.SecureRandom;
import java.math.BigInteger;

public final class RandomString {

    private SecureRandom random = new SecureRandom();

    // return a randomly generated string of length 6
    public String nextString() {
        return new BigInteger(30, random).toString(32);
    }

    public static void main(String[] args) {
        RandomString rs = new RandomString();

        System.out.println(rs.nextString());
    }
}

