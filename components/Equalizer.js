export default function Equalizer() {
  return (
    <div className="flex h-1 w-4 items-center gap-0.5">
      <span className="w-0.75 motion-safe:animate-shrink h-3 rounded-sm bg-spotify-green" />
      <span className="w-0.75 motion-safe:animate-expand h-1.5 rounded-sm bg-spotify-green" />
      <span className="w-0.75 motion-safe:animate-shrink h-3 rounded-sm bg-spotify-green" />
    </div>
  )
}
