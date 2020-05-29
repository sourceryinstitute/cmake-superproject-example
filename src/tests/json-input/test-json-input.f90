program main
   use yafyaml, only : Parser, Configuration, FileStream
   implicit none

   type(Parser) p
   type(Configuration) c
   logical sanity

   p = Parser('core')
   c = p%load(FileStream('input.json'))
   sanity = c%at('science')

   if (.not. sanity) error stop "Test failed"

   sync all
   if (this_image()==1) print *,"Test passed"
end program
