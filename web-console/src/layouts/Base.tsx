interface BaseProps {
  children: React.ReactNode;
}

export default function Base(props: BaseProps) {
  return (
    <>
    basic bitch
    {props.children}
    </>
  );
}
