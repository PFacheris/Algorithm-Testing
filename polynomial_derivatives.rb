#!/usr/bin/ruby
class TraubAlgorithm
    def initialize(fileName)
        File.open(fileName, "r") do |infile|
            @n = Integer(infile.gets)
            @a = infile.gets.split.map(&:to_f)
            @x = infile.gets.to_f
            
            puts "Evaluating:"

            traub
        end
    end
    
    def traub
        multiple = 1
        for j in 0...@n
            if j > 0
                multiple *= j
            end
            puts T(@n, j) / (@x ** j) * multiple
        end 
    end
    
    def T(i, j)
        if j == -1
            return @a[@n - 1 - i] * (@x ** (@n - i - 1))
        elsif i == j
            return @a.last * (@x ** @n)
        else
            return T(i-1, j-1) + T(i-1, j)
        end
    end
end

if __FILE__ == $PROGRAM_NAME
    if ARGV.length > 0 and ARGV.length < 2
        traubTest = TraubAlgorithm.new(ARGV[0])
    else
        puts "Invalid number of arguments. Correct use is " + $PROGRAM_NAME + " [parameter file]"
    end
end
