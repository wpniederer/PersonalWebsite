import Container from './container'

export default function Footer() {
  return (
    <footer className="bg-accent-1 border-t border-accent-2">
      <Container>
        <div className="py-8 flex flex-col lg:flex-row items-center">
          <h3 className="text-4xl lg:text-5xl font-bold tracking-tighter leading-tight text-center lg:text-left mb-10 lg:mb-0 lg:pr-4 lg:w-1/2">
             Contact me
          </h3>
          <div className="flex flex-col lg:flex-col justify-center items-center lg:pl-4 lg:w-1/2">
            <a
              href={`https://github.com/wpniederer`}
              className="mx-3 font-bold hover:underline"
            >
              Walt@GitHub
            </a>
            <a
              href={`mailto:wpniederer@gmail.com`}
              className="mx-3 font-bold hover:underline"
            >
              Walt@Email
            </a>
          </div>
        </div>
      </Container>
    </footer>
  )
}
