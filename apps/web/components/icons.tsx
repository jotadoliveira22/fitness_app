type IconProps = { className?: string };

export function DumbbellIcon({ className }: IconProps) {
  return (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2} strokeLinecap="round" className={className}>
      <path d="M6.5 6.5v11M17.5 6.5v11M2 9.5v5M22 9.5v5M4 8.5h5M4 15.5h5M15 8.5h5M15 15.5h5" />
    </svg>
  );
}

export function LeafIcon({ className }: IconProps) {
  return (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2} strokeLinecap="round" strokeLinejoin="round" className={className}>
      <path d="M4 20c8 0 15-6 16-16-10 1-16 8-16 16Z" />
      <path d="M4 20c2-4 6-9 12-12" />
    </svg>
  );
}

export function TrendingUpIcon({ className }: IconProps) {
  return (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2} strokeLinecap="round" strokeLinejoin="round" className={className}>
      <path d="M3 17l6-6 4 4 8-8" />
      <path d="M15 6h6v6" />
    </svg>
  );
}

export function CalendarIcon({ className }: IconProps) {
  return (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2} strokeLinecap="round" strokeLinejoin="round" className={className}>
      <rect x="3" y="5" width="18" height="16" rx="2" />
      <path d="M3 10h18M8 3v4M16 3v4" />
    </svg>
  );
}

export function FlameIcon({ className }: IconProps) {
  return (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2} strokeLinecap="round" strokeLinejoin="round" className={className}>
      <path d="M12 2c1 3-2 4-2 7a4 4 0 0 0 8 0c0-1.5-1-2.5-1-2.5.5 3-1.5 4-1.5 4C17 8 14 6 12 2Z" />
      <path d="M8 14a4 4 0 1 0 8 0c0-2-1.5-3-2-5-1 2-6 2-6 5Z" />
    </svg>
  );
}

export function CheckCircleIcon({ className }: IconProps) {
  return (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2} strokeLinecap="round" strokeLinejoin="round" className={className}>
      <circle cx="12" cy="12" r="9" />
      <path d="M8 12l3 3 5-6" />
    </svg>
  );
}

export function MealIcon({ className }: IconProps) {
  return (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2} strokeLinecap="round" strokeLinejoin="round" className={className}>
      <path d="M7 2v7a2 2 0 0 0 2 2v11M7 2v7M11 2v9M15 2c-1.5 0-2.5 1.5-2.5 3.5S13.5 12 15 12s2.5-1.5 2.5-3.5S16.5 2 15 2ZM15 12v10" />
    </svg>
  );
}

export function ScaleIcon({ className }: IconProps) {
  return (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2} strokeLinecap="round" strokeLinejoin="round" className={className}>
      <path d="M12 3v3M5 6h14M5 6l-2 7a3.5 3.5 0 0 0 7 0L8 6M19 6l-2 7a3.5 3.5 0 0 0 7 0L22 13" />
      <rect x="6" y="17" width="12" height="4" rx="1" />
    </svg>
  );
}

export function CameraIcon({ className }: IconProps) {
  return (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2} strokeLinecap="round" strokeLinejoin="round" className={className}>
      <path d="M4 8a2 2 0 0 1 2-2h1.5l1-1.5h7l1 1.5H18a2 2 0 0 1 2 2v10a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V8Z" />
      <circle cx="12" cy="13" r="3.5" />
    </svg>
  );
}
