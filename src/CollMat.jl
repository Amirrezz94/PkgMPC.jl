function Collocation_Matrix(N)

      #Radau
      if  N == 2

      t1 = 0.3333333
      t2 = 1.0

      M1 = [
            t1 1 / 2 * t1^2
            t2 1 / 2 * t2^2
            ]
      M2 = [
            1 t1
            1 t2
            ]

      M = M1 * inv(M2)

      elseif  N == 3

            t1 = 0.155051
            t2 = 0.644949
            t3 = 1.0

            M1 = [
                  t1 1 / 2 * t1^2 1 / 3 * t1^3
                  t2 1 / 2 * t2^2 1 / 3 * t2^3
                  t3 1 / 2 * t3^2 1 / 3 * t3^3
                  ]
            M2 = [
                  1 t1 t1^2
                  1 t2 t2^2
                  1 t3 t3^2
                  ]

            M = M1 * inv(M2)

      elseif N == 4

            t1 = 0.088588;
            t2 = 0.409467;
            t3 = 0.787659;
            t4 = 1;


            M1 = [
                  t1 1 / 2 * t1^2 1 / 3 * t1^3 1 / 4 * t1^4
                  t2 1 / 2 * t2^2 1 / 3 * t2^3 1 / 4 * t2^4
                  t3 1 / 2 * t3^2 1 / 3 * t3^3 1 / 4 * t3^4
                  t4 1 / 2 * t4^2 1 / 3 * t4^3 1 / 4 * t4^4
                  ]
            M2 = [
                  1 t1 t1^2 t1^3
                  1 t2 t2^2 t2^3
                  1 t3 t3^2 t3^3
                  1 t4 t4^2 t4^3
                  ]

            M = M1 * inv(M2)

      elseif N == 5

            t1 = 0.057104;
            t2 = 0.276843;
            t3 = 0.583590;
            t4 = 0.860240;
            t5 = 1;

            M1 = [
                  t1 1 / 2 * t1^2 1 / 3 * t1^3 1 / 4 * t1^4  1 / 5 * t1^5
                  t2 1 / 2 * t2^2 1 / 3 * t2^3 1 / 4 * t2^4  1 / 5 * t2^5
                  t3 1 / 2 * t3^2 1 / 3 * t3^3 1 / 4 * t3^4  1 / 5 * t3^5
                  t4 1 / 2 * t4^2 1 / 3 * t4^3 1 / 4 * t4^4  1 / 5 * t4^5
                  t4 1 / 2 * t4^2 1 / 3 * t4^3 1 / 4 * t4^4  1 / 5 * t5^5
                  ]
            M2 = [
                  1 t1 t1^2 t1^3 t1^4
                  1 t2 t2^2 t2^3 t2^4
                  1 t3 t3^2 t3^3 t3^4
                  1 t4 t4^2 t4^3 t4^4
                  1 t4 t4^2 t4^3 t5^4
                  ]

            M = M1 * inv(M2)

      end


      return M
end
