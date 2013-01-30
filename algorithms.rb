require 'benchmark'

$THRESHOLD = 32 #Requires experimental adjustment for Processor Architecture on a case-by-case basis.
def strassen(a,b)
    aRows = a.length
    aCols = a[0].length
    bRows = b.length
    bCols = b[0].length
    #Break Point
    if (aCols <= $THRESHOLD)
       return c = classical(a, b)
    elsif (aCols == bRows)
        a_11, a_12, a_21, a_22, b_11, b_12, b_21, b_22, c_11, c_12, c_21, c_22 = Array.new(12){Array.new(aRows/2) { Array.new(bCols/2,0) }}
        (0...aRows).each do |i|
            (0...bCols).each do |j|
                if i < aRows / 2 and j < bCols / 2
                    a_11[i][j] = a[i][j]
                    b_11[i][j] = b[i][j]
                elsif j >= bCols / 2 and i < aRows / 2
                    a_12[i][j - bCols / 2] = a[i][j]
                    b_12[i][j - bCols / 2] = b[i][j]
                elsif i >= aRows / 2 and j < bCols / 2
                    a_21[i - aRows / 2][j] = a[i][j]
                    b_21[i - aRows / 2][j] = b[i][j]
                else
                    a_22[i - aRows / 2][j - bCols / 2] = a[i][j]
                    b_22[i - aRows / 2][j - bCols / 2] = b[i][j]
                end
            end
        end

        m1 = strassen(simpleMatrixOperation(a_11, a_22), simpleMatrixOperation(b_11, b_22))
        m2 = strassen(simpleMatrixOperation(a_21, a_22), b_11)
        m3 = strassen(a_11, simpleMatrixOperation(b_12, b_22, false))
        m4 = strassen(a_22, simpleMatrixOperation(b_21, b_11, false))
        m5 = strassen(simpleMatrixOperation(a_11, a_12), b_22)
        m6 = strassen(simpleMatrixOperation(a_21, a_11, false), simpleMatrixOperation(b_11, b_12))
        m7 = strassen(simpleMatrixOperation(a_12, a_22, false), simpleMatrixOperation(b_21, b_22))

        c_11 = simpleMatrixOperation(simpleMatrixOperation(simpleMatrixOperation(m1, m4), m5, false), m7)
        c_12 = simpleMatrixOperation(m3, m5)
        c_21 = simpleMatrixOperation(m2, m4)
        c_22 = simpleMatrixOperation(simpleMatrixOperation(simpleMatrixOperation(m1, m2, false), m3), m6)

        c = Array.new(aRows) { Array.new(bCols,0) }
        (0...aRows).each do |i|
            (0...bCols).each do |j|
                if i < aRows / 2 and j < bCols / 2
                    c[i][j] = c_11[i][j]
                elsif j >= bCols / 2 and i < aRows / 2
                    c[i][j] = c_12[i][j - bCols / 2]
                elsif i >= aRows / 2 and j < bCols / 2
                    c[i][j] = c_21[i - aRows / 2][j]
                else
                    c[i][j] = c_22[i - aRows / 2][j - bCols / 2] 
                end
            end
        end     
        return c
    else
        puts "Invalid operation."
    end
end

def simpleMatrixOperation(a, b, add=true)
    aRows = a.length
    aCols = a[0].length
    bRows = b.length
    bCols = b[0].length
    if aRows == bRows and aCols == bCols
        c = Array.new(aRows) { Array.new(bCols,0) }
        (0...aRows).each do |i|
            (0...bCols).each do |j|
                if (add)
                    c[i][j] = a[i][j] + b[i][j]
                else
                    c[i][j] = a[i][j] - b[i][j]
                end
            end
        end
        c
    end
end

def classical(a,b)
    aRows = a.length
    aCols = a[0].length
    bRows = b.length
    bCols = b[0].length
    if (aCols == bRows)
        c = Array.new(aRows) { Array.new(bCols,0) }
        (0...aRows).each do |i|
            (0...bCols).each do |j|
                (0...aCols).each do |k|
                    c[i][j] += a[i][k] * b[k][j];
                end
            end
        end
        c
    else
        puts "Invalid operation."
    end
end

def fill(n)
    value = []
    (0...n).each do |i|
        value[i] = []
        (0...n).each do |j|
            value[i][j] = Random.rand() * 1000
        end
    end
    value
end


if __FILE__ == $PROGRAM_NAME
    if ARGV.length > 0 and ARGV.length < 2
        dimension = ARGV[0].to_i
        if Math.log2(dimension) % 1 == 0
            a = fill(dimension)
            b = fill(dimension)

            puts "A:\n"
            puts a.map { |x| x.inspect }.join("\n")
            puts "B:\n"
            puts b.map { |x| x.inspect }.join("\n")
            puts "Strassen, (A)(B):\n"
            resultS = strassen(a, b)
            puts resultS.map { |x| x.inspect }.join("\n")
            puts "Classical, (A)(B):\n"
            resultC = classical(a, b)
            puts resultC.map { |x| x.inspect }.join("\n")
            puts "Error Bound:\n"
            puts simpleMatrixOperation(resultC, resultS, false).map { |x| x.inspect }.join("\n")

            #For Benchmarking Purposes
            #puts Benchmark.measure {strassen(a,b)}
            #puts Benchmark.measure {classical(a,b)}
        else
            puts "Please input a dimension that is a power of two."
        end
    else
        puts "Invalid number of arguments. Correct use is " + $PROGRAM_NAME + " [dimension]"
    end
end
