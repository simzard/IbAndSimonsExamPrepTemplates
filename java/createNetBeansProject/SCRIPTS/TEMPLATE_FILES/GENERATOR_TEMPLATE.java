package generators;

import javax.persistence.Persistence;

public class Generator {

    public static void generate(int number) {
        RandomString rs = new RandomString();

        for (int i = 0; i < number; i++) {
        }

    }


    public static void main(String[] args) {
        generate(10);
    }
}
