program main
   use yafyaml, only : Parser, Configuration, FileStream
   implicit none

   type(Parser) p
   type(Configuration) c
   logical sanity

   p = Parser('core')
   c = p%load(FileStream('input.json'))
   sanity = c%at('science')

   if (sanity) print *,"Test passed"
end program
