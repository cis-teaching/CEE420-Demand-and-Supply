"""Main file."""
from __future__ import annotations
from typing import Optional
from copy import copy
from random import uniform, shuffle, random
from itertools import product


class Agent:
    """Base class for seller and buyer."""

    def __init__(self, name: str, limit: float = 0.0) -> None:
        """Initialize base agent."""
        self._name: str = name
        self._limit: float = limit

        self._initial: float = float("inf")
        self._prices: list = [self._initial]
        self._success: bool = False

    def __repr__(self) -> str:
        """Return class and name."""
        return f"{self.__class__.__name__}: {self._name}"

    @property
    def name(self) -> str:
        """Return name of the agent."""
        return self._name

    @property
    def price(self) -> float:
        """Return price of the agent."""
        return self._prices[-1]

    @price.setter
    def price(self, price: float) -> None:
        self._prices.append(price)
        self._success = True

    @property
    def initial(self) -> float:
        """Return initial price for negotiation."""
        return self._initial

    @initial.setter
    def initial(self, price: float) -> None:
        """Set initial price."""
        self._initial = price
        self._prices.append(price)

    @property
    def limit(self) -> float:
        """Return limut of the agent."""
        return self._limit

    def adjust_price(self) -> None:
        """Adjust new price for the next round."""
        raise NotImplementedError

    def _get_adjustment(self, kind: str = "fixed") -> float:
        """Return the adjustment price."""
        adjustment: float = 1

        if kind == "random":
            adjustment = 1 if random() < 0.5 else 0
        elif kind == "function":

            def f(x):
                return (0.2 * x + 1) ** 0.5

            adjustment = f(abs(self.price - self.limit))

        return adjustment


class Buyer(Agent):
    """Buyer Agent."""

    def adjust_price(self) -> None:
        """Adjust new price for the next round."""
        adjustment: float = self._get_adjustment()
        if self._success:
            self._prices.append(self.price - adjustment)
        else:
            self._prices.append(min(self.price + adjustment, self.limit))
        self._success = False


class Seller(Agent):
    """Seller Agent."""

    def adjust_price(self) -> None:
        """Adjust new price for the next round."""
        adjustment: float = self._get_adjustment()
        if self._success:
            self._prices.append(self.price + adjustment)
        else:
            self._prices.append(max(self.price - adjustment, self.limit))
        self._success = False


class Meeting:
    """Class to make the deal."""

    def __init__(
        self,
        buyer: Buyer,
        seller: Seller,
        strategy: str = "buyer_decides",
    ) -> None:
        """Initialize meeting."""
        self._buyer: Buyer = buyer
        self._seller: Seller = seller
        self._strategy: str = strategy
        self._transaction: Optional[float] = None

    def __repr__(self) -> str:
        """Return class and name."""
        return f"Meeting {self._buyer.name} & {self._seller.name}"

    def negotiation(self, strategy: Optional[str] = None) -> bool:
        """Negotiation between seller and buyer. If successful True."""
        strategy = strategy if strategy else self._strategy

        if self._buyer.initial == float("inf"):
            self._buyer.initial = self._seller.limit

        if self._seller.initial == float("inf"):
            self._seller.initial = self._buyer.limit

        bid = self._buyer.price
        ask = self._seller.price

        if strategy == "negotiate":
            minimum = max(bid, self._seller.limit)
            maximum = min(ask, self._buyer.limit)

            if minimum <= maximum:
                self._transaction = uniform(minimum, maximum + 1)

        elif strategy == "buyer_decides":
            self._transaction = ask if ask <= bid else None

        if self._transaction:
            self._buyer.price = self._transaction
            self._seller.price = self._transaction

        return True if self._transaction else False


class Session:
    """Class to simulate multiple agent interactions."""

    def __init__(
        self,
        buyers: list[Buyer],
        sellers: list[Seller],
        strategy: str = "buyer_decides",  # ,"negotiate",
    ) -> None:
        """Initialize session."""
        self._buyers: list[Buyer] = buyers
        self._sellers: list[Seller] = sellers
        self._strategy: str = strategy

    def run(self) -> None:
        """Run session."""
        sellers: set[Seller] = set(copy(self._sellers))
        buyers: set[Buyer] = set(copy(self._buyers))
        counter: int = 0

        price = []

        for i in range(100):
            counter += 1

            # initialize helping variables
            waiting: set = set()

            print(f"==> This is round {counter:02d}")

            # create list to shuffle
            list_buyers = list(buyers)
            list_sellers = list(sellers)

            # randomly mix agents
            shuffle(list_buyers)
            shuffle(list_sellers)

            # get all possible combinations of buyers and sellers
            for buyer, seller in product(list_buyers, list_sellers):
                # stop this meeting since one is already done
                if buyer in waiting or seller in waiting:
                    continue

                # try to find a price
                success = Meeting(buyer, seller, self._strategy).negotiation()
                # print(buyer,buyer.price,seller,seller.price)
                if success:
                    print(f"New sale between {buyer} and {seller} for {buyer.price}")
                    price.append(buyer.price)
                    waiting.add(buyer)
                    waiting.add(seller)

                # NOTE: Not working yet need to stop simulation when everybody met
                # # allow to adjust price during next negotiation in this round
                # else:
                #     buyer.adjust_price()
                #     seller.adjust_price()

            # update price after the end of this round
            for buyer in buyers:
                buyer.adjust_price()

            for seller in sellers:
                seller.adjust_price()

        print(
            "Average price after the simulations: ",
            round(sum(price[-9:]) / len(price[-9:])),
        )
        # print(price)


def main():
    """Run main function of the library."""
    # initialize buyers
    buyers = [
        # Buyer("Bob", limit=30),
        Buyer("Bob", limit=80),
        Buyer("Ben", limit=70),
        Buyer("Boo", limit=40),
    ]
    # initialize sellers
    sellers = [
        Seller("Sue", limit=20),
        Seller("Sam", limit=30),
        Seller("Sun", limit=40),
        Seller("Sua", limit=50),
    ]

    # create session
    session = Session(buyers, sellers)
    session.run()


if __name__ == "__main__":
    main()
